import re
import argparse

def parse_value(value_str):
    """
    Parse values with engineering notation (e.g., '1.2345u' or '123.45n')
    Returns float in base units
    """
    if value_str == "0." or value_str == "0":
        return 0.0

    # Multipliers for different unit prefixes
    multipliers = {
        "n": 1e-9,  # nano
        "u": 1e-6,  # micro
        "m": 1e-3,  # milli
        "": 1.0,  # no prefix
    }

    # Extract number and unit using regex
    match = re.match(r"([-+]?\d*\.?\d+)([num])?", value_str)
    if match:
        number = float(match.group(1))
        unit = match.group(2) if match.group(2) else ""
        return number * multipliers[unit]
    return 0.0

def process_data(text):
    """Process the raw data text and return voltage-current pairs"""
    data_pairs = []

    # Split text into lines
    lines = text.strip().split("\n")

    # Find where the data starts (after the headers)
    start_idx = 0
    for i, line in enumerate(lines):
        if "volt" in line.lower() and "current" in line.lower():
            start_idx = i + 1
            break

    # Process each data line
    for line in lines[start_idx:]:
        # Skip empty lines or lines without data
        if not line.strip() or "y" in line:  # 'y' appears at the end of your data
            continue

        # Split the line and clean up the values
        parts = line.strip().split()
        if len(parts) >= 2:
            voltage = parse_value(parts[0])
            current = parse_value(parts[1])
            data_pairs.append((voltage, current))

    return data_pairs

def save_to_csv(data_pairs, filename="voltage_current_data.csv"):
    """Save the processed data to a CSV file"""
    with open(filename, "w") as f:
        f.write("voltage,current\n")
        for voltage, current in data_pairs:
            f.write(f"{voltage:.12f},{current:.12f}\n")

def main():
    # Set up command line argument parser
    parser = argparse.ArgumentParser(description='Convert voltage-current data from text to CSV.')
    parser.add_argument('input_file', help='Input text file containing voltage-current data')
    parser.add_argument('output_file', help='Output CSV file name')
    args = parser.parse_args()

    # Read the input file
    try:
        with open(args.input_file, "r") as f:
            raw_data = f.read()
    except FileNotFoundError:
        print(f"Error: Could not find input file '{args.input_file}'")
        return
    
    # Process the data
    data_pairs = process_data(raw_data)
    
    # Save processed data to CSV
    try:
        save_to_csv(data_pairs, args.output_file)
        print(f"Data successfully saved to {args.output_file}")
    except Exception as e:
        print(f"Error saving CSV file: {e}")

if __name__ == "__main__":
    main()
