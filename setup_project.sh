
#!/bin/bash

read -p "Enter project name: " project_name

main_dir="attendance_tracker_${project_name}"
cleanup() {
    echo "Script interrupted! Archiving project..."
    tar -czf "${main_dir}_archive.tar.gz" "$main_dir"
    rm -rf "$main_dir"
    echo "Archive created and incomplete directory deleted."
    exit 1
}

trap cleanup SIGINT

mkdir "$main_dir"

echo "Directory $main_dir created successfully"
# Create subdirectories
mkdir "$main_dir/Helpers"
mkdir "$main_dir/reports"

# Create required files
touch "$main_dir/attendance_checker.py"
touch "$main_dir/Helpers/assets.csv"
touch "$main_dir/Helpers/config.json"
touch "$main_dir/reports/reports.log"

echo '{
  "warning": 75,
  "failure": 50
}' > "$main_dir/Helpers/config.json"

read -p "Do you want to update attendance thresholds? (yes/no): " answer

if [ "$answer" = "yes" ]; then

    read -p "Enter Warning Threshold (default 75): " warning
    read -p "Enter Failure Threshold (default 50): " failure

    # Set defaults if empty
    if [ -z "$warning" ]; then
        warning=75
    fi

    if [ -z "$failure" ]; then
        failure=50
    fi

    # Validate numeric
    if [[ "$warning" =~ ^[0-9]+$ ]] && [[ "$failure" =~ ^[0-9]+$ ]]; then
        
        sed -i "s/\"warning\":.*/\"warning\": $warning,/" "$main_dir/Helpers/config.json"
        sed -i "s/\"failure\":.*/\"failure\": $failure/" "$main_dir/Helpers/config.json"

        echo "Thresholds updated successfully."
    else
        echo "Invalid input. Using default values."
    fi

fi

echo "Performing system health check..."
if python3 --version > /dev/null 2>&1; then
    echo "Python3 is installed."
else
    echo "Warning: Python3 is NOT installed."
fi


echo "Project setup completed successfully!"

