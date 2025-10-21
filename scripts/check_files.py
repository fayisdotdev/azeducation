import os
import re

# Path to your lib folder
LIB_DIR = r"D:/OLD D/Flutter/azeducation/lib"

# Regex to detect Dart imports
IMPORT_REGEX = re.compile(r"import\s+['\"]([^'\"]+\.dart)['\"]")

file_imports = {}  # {file_path: set of imported dart paths}

# Step 1: List all Dart files and read imports
for root, dirs, files in os.walk(LIB_DIR):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            rel_path = os.path.relpath(file_path, LIB_DIR).replace("\\", "/")
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
            imports = set()
            for match in IMPORT_REGEX.finditer(content):
                imp_path = match.group(1)
                # Convert package imports to relative path
                if imp_path.startswith("package:azeducation/"):
                    imp_path = imp_path.replace("package:azeducation/", "")
                imports.add(imp_path)
            file_imports[rel_path] = imports

# Step 2: Collect all imported files
all_imported = set()
for imports in file_imports.values():
    all_imported.update(imports)

# Step 3: Detect unused Dart files
unused_files = [f for f in file_imports.keys() if f not in all_imported]

print(f"Total Dart files: {len(file_imports)}")
print(f"Potentially unused files: {len(unused_files)}")
for f in unused_files:
    print(f"- {f}")

# Optional: print full dependency map
print("\nDependency map:")
for f, imports in file_imports.items():
    print(f"{f} imports:")
    for imp in imports:
        print(f"  - {imp}")
