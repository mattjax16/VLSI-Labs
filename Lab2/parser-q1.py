import pandas as pd
import argparse


def process_hspice_data(data_text):
    # Initialize lists to store the data
    voltages = []
    currents = []
    threshold_voltages = []

    # Find the starting points for both datasets
    lines = data_text.split('\n')

    current_data = False
    threshold_data = False

    for line in lines:
        # Skip empty lines
        if not line.strip():
            continue

        # Check for start of current data
        if line.strip().startswith('volt         current'):
            current_data = True
            threshold_data = False
            continue

        # Check for start of threshold voltage data
        if line.strip().startswith('volt         lv9'):
            current_data = False
            threshold_data = True
            continue

        # Process data lines
        if current_data or threshold_data:
            # Skip the headers
            if 'm1' in line:
                continue

            parts = line.strip().split()
            if len(parts) >= 2:
                try:
                    # Convert voltage to millivolts
                    if 'm' in parts[0]:
                        # Already in millivolts, just remove the 'm' suffix
                        voltage = float(parts[0].rstrip('m'))
                    else:
                        # Convert V to mV
                        voltage = float(parts[0]) * 1000

                    if current_data:
                        # Convert all current values to microamps
                        value = parts[1].rstrip('u').rstrip('m')
                        if 'm' in parts[1]:
                            current = float(value) * 1000  # Convert mA to μA
                        else:
                            current = float(value)  # Already in μA
                        voltages.append(voltage)
                        currents.append(current)
                    elif threshold_data:
                        # Handle threshold voltage values
                        # Already in millivolts, just remove the 'm' suffix
                        value = float(parts[1].rstrip('m'))
                        threshold_voltages.append(value)
                except ValueError:
                    continue

    # Create DataFrame
    df = pd.DataFrame({
        'Voltage_mV': voltages[:len(threshold_voltages)],  # Make sure lengths match
        'Current_uA': currents[:len(threshold_voltages)],
        'Threshold_Voltage_mV': threshold_voltages
    })

    return df


def main():
    # Set up command line argument parser
    parser = argparse.ArgumentParser(description='Process HSPICE data file to CSV')
    parser.add_argument('input_file', help='Input HSPICE text file path')
    parser.add_argument('output_file', help='Output CSV file path')

    # Parse arguments
    args = parser.parse_args()

    # Read input file
    try:
        with open(args.input_file, 'r') as file:
            data_text = file.read()
    except FileNotFoundError:
        print(f"Error: Input file '{args.input_file}' not found")
        return
    except Exception as e:
        print(f"Error reading input file: {e}")
        return

    # Process data
    df = process_hspice_data(data_text)

    # Save to CSV
    try:
        df.to_csv(args.output_file, index=False, float_format='%.3f')
        print(f"Data successfully saved to {args.output_file}")
    except Exception as e:
        print(f"Error saving CSV file: {e}")


if __name__ == "__main__":
    main()