import re
import argparse


def parse_value(value_str, to_microamps=False):
    """
    Parse values with engineering notation (e.g., '1.2345u' or '123.45n')
    Returns float in base units or microamps for current values

    Args:
        value_str: string containing number and optional unit
        to_microamps: if True, converts the value to microamps
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

    # Conversion factors to microamps
    to_ua_multipliers = {
        "n": 1e-3,  # nano -> micro
        "u": 1.0,  # micro -> micro
        "m": 1e3,  # milli -> micro
        "": 1e6,  # base -> micro
    }

    # Extract number and unit using regex
    match = re.match(r"([-+]?\d*\.?\d+)([num])?", value_str)
    if match:
        number = float(match.group(1))
        unit = match.group(2) if match.group(2) else ""

        if to_microamps:
            return number * to_ua_multipliers[unit]
        else:
            return number * multipliers[unit]
    return 0.0


def process_data(text):
    """Process the raw HSPICE text and return voltage-current-threshold pairs"""
    data = []

    # Split text into lines
    lines = text.strip().split("\n")

    # Process the file in two passes - one for V-I data and one for threshold voltage
    voltage_data = {}  # Store voltage and current temporarily
    threshold_data = {}  # Store threshold voltage data

    current_section = None

    for line in lines:
        line = line.strip()

        # Skip empty lines
        if not line:
            continue

        # Check for new data section
        if "volt         current" in line:
            current_section = "vi"
            continue
        elif "volt         lv9" in line:
            current_section = "threshold"
            continue

        # Skip header lines and non-data lines
        if "x" in line or "m1" in line or "y" in line or not line[0].isspace():
            continue

        # Parse data lines
        parts = line.strip().split()
        if len(parts) >= 2:
            voltage = parse_value(parts[0])
            if current_section == "vi":
                current = parse_value(parts[1], to_microamps=True)
                voltage_data[voltage] = current
            elif current_section == "threshold":
                threshold = parse_value(parts[1])
                threshold_data[voltage] = threshold

    # Combine the data
    voltages = sorted(set(voltage_data.keys()) & set(threshold_data.keys()))
    for voltage in voltages:
        data.append((voltage, voltage_data[voltage], threshold_data[voltage]))

    return data


def save_to_csv(data_triplets, filename="voltage_current_data.csv"):
    """Save the processed data to a CSV file"""
    with open(filename, "w") as f:
        f.write("voltage,current,threshold\n")  # voltage in V, current in µA, threshold in V
        for voltage, current, threshold in data_triplets:
            f.write(f"{voltage:.12f},{current:.12f},{threshold:.12f}\n")


def main():
    parser = argparse.ArgumentParser(description='Convert HSPICE output to CSV.')
    parser.add_argument('input_file', help='Input text file containing HSPICE data')
    parser.add_argument('output_file', help='Output CSV file name')
    args = parser.parse_args()

    try:
        # Read the input file
        with open(args.input_file, "r") as f:
            raw_data = f.read()

        # Process the data
        data_triplets = process_data(raw_data)

        # Save processed data to CSV
        save_to_csv(data_triplets, args.output_file)
        print(f"Data successfully saved to {args.output_file}")
        print("Note: Current values are in microamps (µA), voltages in volts (V)")

        # Print first few entries as example
        print("\nFirst few entries:")
        for voltage, current, threshold in data_triplets[:5]:
            print(f"Voltage: {voltage:.6f} V, Current: {current:.6f} µA, Threshold: {threshold:.6f} V")

    except Exception as e:
        print(f"Error processing file: {e}")


if __name__ == "__main__":
    main()