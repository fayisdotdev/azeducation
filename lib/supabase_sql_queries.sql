-- Enable required extensions for UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Helper function to get current auth user ID
CREATE OR REPLACE FUNCTION public.current_auth_uid() 
RETURNS uuid LANGUAGE sql STABLE AS $$
  SELECT (auth.uid())::uuid;
$$;

REVOKE EXECUTE ON FUNCTION public.current_auth_uid() FROM anon, authenticated;

-- Users table
CREATE TABLE IF NOT EXISTS public.users (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text,
  email text UNIQUE,
  password text,
  mobile text UNIQUE,
  is_teacher boolean DEFAULT false,
  is_student boolean DEFAULT false,
  is_admin boolean DEFAULT false,
  subjects text[] DEFAULT '{}'::text[],
  courses text[] DEFAULT '{}'::text[],
  created_at timestamptz DEFAULT now(),
  role text DEFAULT 'idk'::text,
  core_subject_id uuid
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_users_core_subject_id ON public.users(core_subject_id);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON public.users(created_at);

-- Placeholder is_publicly_visible function to allow future public visibility logic
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'is_publicly_visible') THEN
    CREATE OR REPLACE FUNCTION public.is_publicly_visible() RETURNS boolean
    LANGUAGE sql STABLE AS $$
      SELECT false;
    $$;
    REVOKE EXECUTE ON FUNCTION public.is_publicly_visible() FROM anon, authenticated;
  END IF;
END;
$$;

-- Policies for users table
CREATE POLICY users_select_authenticated ON public.users FOR SELECT TO authenticated
  USING (id = public.current_auth_uid() OR public.is_publicly_visible() IS TRUE);

CREATE POLICY users_select_owner ON public.users FOR SELECT TO authenticated
  USING (id = public.current_auth_uid());

CREATE POLICY users_insert_authenticated ON public.users FOR INSERT TO authenticated
  WITH CHECK ((id IS NULL) OR (id = public.current_auth_uid()));

CREATE POLICY users_update_owner ON public.users FOR UPDATE TO authenticated
  USING (id = public.current_auth_uid())
  WITH CHECK (id = public.current_auth_uid());

CREATE POLICY users_delete_owner ON public.users FOR DELETE TO authenticated
  USING (id = public.current_auth_uid());

-- Universities table
CREATE TABLE IF NOT EXISTS public.universities (
  university_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  university_name text UNIQUE,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.universities ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_universities_created_at ON public.universities(created_at);

CREATE POLICY universities_select_public ON public.universities FOR SELECT TO authenticated
  USING (true);

CREATE POLICY universities_admins_write ON public.universities FOR ALL TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);

-- Courses table
CREATE TABLE IF NOT EXISTS public.courses (
  course_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  university_id uuid REFERENCES public.universities(university_id) ON DELETE SET NULL,
  course_name text,
  created_at timestamptz DEFAULT now(),
  category_id uuid REFERENCES public.course_categories(category_id) ON DELETE SET NULL
);

ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_courses_university_id ON public.courses(university_id);
CREATE INDEX IF NOT EXISTS idx_courses_category_id ON public.courses(category_id);

CREATE POLICY courses_select_authenticated ON public.courses FOR SELECT TO authenticated
  USING (true);

CREATE POLICY courses_admins_write ON public.courses FOR INSERT, UPDATE, DELETE TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);

-- Subjects table
CREATE TABLE IF NOT EXISTS public.subjects (
  subject_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id uuid REFERENCES public.courses(course_id) ON DELETE SET NULL,
  university_id uuid REFERENCES public.universities(university_id) ON DELETE SET NULL,
  subject_name text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_subjects_course_id ON public.subjects(course_id);
CREATE INDEX IF NOT EXISTS idx_subjects_university_id ON public.subjects(university_id);

CREATE POLICY subjects_select_authenticated ON public.subjects FOR SELECT TO authenticated
  USING (true);

CREATE POLICY subjects_admins_write ON public.subjects FOR INSERT, UPDATE, DELETE TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);

-- Subject details table
CREATE TABLE IF NOT EXISTS public.subject_details (
  detail_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  subject_id uuid REFERENCES public.subjects(subject_id) ON DELETE CASCADE,
  course_id uuid REFERENCES public.courses(course_id) ON DELETE SET NULL,
  university_id uuid REFERENCES public.universities(university_id) ON DELETE SET NULL,
  description text,
  duration text,
  fees numeric,
  note1 text,
  note2 text,
  note3 text,
  syllabus text,
  image_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.subject_details ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_subject_details_subject_id ON public.subject_details(subject_id);
CREATE INDEX IF NOT EXISTS idx_subject_details_course_id ON public.subject_details(course_id);
CREATE INDEX IF NOT EXISTS idx_subject_details_university_id ON public.subject_details(university_id);

CREATE POLICY subject_details_select_authenticated ON public.subject_details FOR SELECT TO authenticated
  USING (true);

CREATE POLICY subject_details_admins_write ON public.subject_details FOR INSERT, UPDATE, DELETE TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);

-- Course details table
CREATE TABLE IF NOT EXISTS public.course_details (
  detail_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  subject_id uuid REFERENCES public.subjects(subject_id) ON DELETE SET NULL,
  course_id uuid REFERENCES public.courses(course_id) ON DELETE CASCADE,
  university_id uuid REFERENCES public.universities(university_id) ON DELETE SET NULL,
  description text,
  duration text,
  fees numeric,
  note1 text,
  note2 text,
  note3 text,
  syllabus text,
  image_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.course_details ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_course_details_course_id ON public.course_details(course_id);
CREATE INDEX IF NOT EXISTS idx_course_details_subject_id ON public.course_details(subject_id);
CREATE INDEX IF NOT EXISTS idx_course_details_university_id ON public.course_details(university_id);

CREATE POLICY course_details_select_authenticated ON public.course_details FOR SELECT TO authenticated
  USING (true);

CREATE POLICY course_details_admins_write ON public.course_details FOR INSERT, UPDATE, DELETE TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);

-- Course categories table
CREATE TABLE IF NOT EXISTS public.course_categories (
  category_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_name text UNIQUE,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.course_categories ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_course_categories_created_at ON public.course_categories(created_at);

CREATE POLICY course_categories_select_public ON public.course_categories FOR SELECT TO authenticated
  USING (true);

CREATE POLICY course_categories_admins_write ON public.course_categories FOR INSERT, UPDATE, DELETE TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);

-- Course videos table
CREATE TABLE IF NOT EXISTS public.course_videos (
  video_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  title text,
  video_url text,
  owner uuid DEFAULT public.current_auth_uid(),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.course_videos ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_course_videos_owner ON public.course_videos(owner);

CREATE POLICY course_videos_select_authenticated ON public.course_videos FOR SELECT TO authenticated
  USING (true);

CREATE POLICY course_videos_insert_authenticated ON public.course_videos FOR INSERT TO authenticated
  WITH CHECK (owner = public.current_auth_uid());

CREATE POLICY course_videos_update_owner ON public.course_videos FOR UPDATE TO authenticated
  USING (owner = public.current_auth_uid())
  WITH CHECK (owner = public.current_auth_uid());

CREATE POLICY course_videos_delete_owner ON public.course_videos FOR DELETE TO authenticated
  USING (owner = public.current_auth_uid());

-- Video classes table
CREATE TABLE IF NOT EXISTS public.video_classes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text,
  video_url text,
  university_id uuid,
  university_name text,
  course_id uuid,
  course_name text,
  subject_id uuid,
  subject_name text,
  category_id uuid,
  category_name text,
  created_at timestamptz DEFAULT timezone('utc', now())
);

ALTER TABLE public.video_classes ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_video_classes_university_id ON public.video_classes(university_id);
CREATE INDEX IF NOT EXISTS idx_video_classes_course_id ON public.video_classes(course_id);
CREATE INDEX IF NOT EXISTS idx_video_classes_subject_id ON public.video_classes(subject_id);

CREATE POLICY video_classes_select_authenticated ON public.video_classes FOR SELECT TO authenticated
  USING (true);

CREATE POLICY video_classes_admins_write ON public.video_classes FOR INSERT, UPDATE, DELETE TO authenticated
  USING ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE)
  WITH CHECK ((SELECT is_admin FROM public.users WHERE id = public.current_auth_uid()) IS TRUE);
