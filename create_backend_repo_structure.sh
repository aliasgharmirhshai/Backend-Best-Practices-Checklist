#!/bin/bash

# Define the root directories
ROOT_DIRS=("frameworks" "common-topics")
FRAMEWORKS=("nestjs" "expressjs" "django")
COMMON_TOPICS=("Error_Handling.md" "Security_Best_Practices.md" "Database_Optimization.md")
NESTJS_FILES=("01_Controllers.md" "02_Services_Providers.md" "03_Modules_DI.md" "04_Pipes_Validation.md" "05_Guards_Auth.md" "06_Interceptors.md" "07_Exception_Filters.md" "README.md")
# Global files for the repository root
ROOT_FILES=(".gitignore" "CODE_OF_CONDUCT.md" "CONTRIBUTING.md" "LICENSE" "README.md")

echo "Starting repository structure creation..."

# 1. Create top-level directories
for dir in "${ROOT_DIRS[@]}"; do
    mkdir -p "$dir"
    echo "Created directory: $dir"
done

# 2. Create framework subdirectories and NestJS content
for framework in "${FRAMEWORKS[@]}"; do
    mkdir -p "frameworks/$framework"
    echo "Created framework directory: frameworks/$framework"
    
    # Create NestJS-specific files
    if [ "$framework" == "nestjs" ]; then
        for file in "${NESTJS_FILES[@]}"; do
            touch "frameworks/nestjs/$file"
            echo "  Created file: frameworks/nestjs/$file"
        done
    fi
done

# 3. Create common topics files
for file in "${COMMON_TOPICS[@]}"; do
    touch "common-topics/$file"
    echo "Created common topic file: common-topics/$file"
done

# 4. Create root repository files
for file in "${ROOT_FILES[@]}"; do
    touch "$file"
    echo "Created root file: $file"
done

echo ""
echo "✅ Structure created successfully!"
echo "You can now initialize your Git repository: git init"
