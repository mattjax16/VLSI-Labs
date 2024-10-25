import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.signal import savgol_filter
from scipy.stats import linregress
import argparse

def find_saturation_region(voltage, current, window_size=21, threshold=0.05):
    """
    Find the saturation region by analyzing the derivative of the I-V curve
    """
    # Calculate the derivative (transconductance)
    gm = np.gradient(current, voltage)
    
    # Smooth the derivative using Savitzky-Golay filter
    gm_smooth = savgol_filter(gm, window_size, 3)
    
    # Calculate the second derivative
    gm2 = np.gradient(gm_smooth, voltage)
    gm2_smooth = savgol_filter(gm2, window_size, 3)
    
    # Find where the second derivative becomes close to zero
    normalized_gm2 = np.abs(gm2_smooth) / np.max(np.abs(gm2_smooth))
    sat_start_idx = np.where(normalized_gm2 < threshold)[0][0]
    
    return sat_start_idx

def main():
    # Set up command line argument parser
    parser = argparse.ArgumentParser(description='Plot and analyze voltage-current data from CSV.')
    parser.add_argument('input_file', help='Input CSV file containing voltage-current data')
    args = parser.parse_args()

    try:
        # Read CSV file
        data = pd.read_csv(args.input_file)
        voltage = data['voltage'].values
        current = data['current'].values
        
        # Find saturation region
        sat_idx = find_saturation_region(voltage, current)
        sat_voltage = voltage[sat_idx]

        # Create visualization
        plt.figure(figsize=(10, 6))
        plt.plot(voltage, current * 1e6, 'b-', label='I-V Curve')
        plt.axvline(x=sat_voltage, color='r', linestyle='--', 
                    label=f'Saturation begins at {sat_voltage:.3f}V')
        plt.grid(True)
        plt.xlabel('Voltage (V)')
        plt.ylabel('Current (µA)')
        plt.title('I-V Characteristic Curve')
        plt.legend()

        # Calculate and print key parameters
        sat_current = current[sat_idx]
        # Linear fit in saturation region
        slope, intercept, r_value, p_value, std_err = linregress(
            voltage[sat_idx:], current[sat_idx:])

        print(f"\nAnalysis Results:")
        print(f"Saturation begins at: {sat_voltage:.3f} V")
        print(f"Current at saturation: {sat_current*1e6:.2f} µA")
        print(f"Linear fit in saturation region:")
        print(f"Slope (conductance): {slope*1e6:.2f} µA/V")
        print(f"R-squared value: {r_value**2:.4f}")

        plt.show()

    except FileNotFoundError:
        print(f"Error: Could not find input file '{args.input_file}'")
    except Exception as e:
        print(f"Error processing data: {e}")

if __name__ == "__main__":
    main()
