import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.signal import savgol_filter
from scipy.stats import linregress
import argparse


def find_saturation_complex(voltage_mv, current_ua, window_size=21, threshold=0.05):
    """
    Complex method uses smoothed derivatives to reduce noise sensitivity.
    Voltage is expected in millivolts, current in microamps.
    """
    try:
        # Convert voltage to V for calculations
        voltage = voltage_mv / 1000.0

        # First derivative
        gm = np.gradient(current_ua, voltage)

        # Smooth first derivative
        gm_smooth = savgol_filter(gm, window_size, 3)

        # Second derivative from smoothed first derivative
        gm2 = np.gradient(gm_smooth, voltage)
        gm2_smooth = savgol_filter(gm2, window_size, 3)

        # Normalize second derivative
        normalized_gm2 = np.abs(gm2_smooth) / np.max(np.abs(gm2_smooth))
        zero_indices = np.where(normalized_gm2 < threshold)[0]

        if len(zero_indices) > 0:
            return zero_indices[0]
        else:
            return np.nan
    except:
        return np.nan


def find_saturation_basic(voltage_mv, current_ua, threshold=1e-2):
    """
    Basic method uses direct derivatives without smoothing.
    Voltage is expected in millivolts, current in microamps.
    """
    try:
        # Convert voltage to V for calculations
        voltage = voltage_mv / 1000.0

        # First derivative
        first_derivative = np.gradient(current_ua, voltage)

        # Second derivative
        second_derivative = np.gradient(first_derivative, voltage)

        # Find where second derivative is close to zero
        zero_indices = np.where(np.abs(second_derivative) < threshold)[0]

        if len(zero_indices) > 0:
            return zero_indices[0]
        else:
            return np.nan
    except:
        return np.nan


def calculate_lambda_from_saturation(voltage_v, current_ua, sat_idx):
    """
    Calculate lambda from the slope of the line in saturation region
    using the relationship: slope = Id_sat * lambda
    """
    # Get saturation region data
    voltage_sat = voltage_v[sat_idx:]
    current_sat = current_ua[sat_idx:]

    # Calculate slope in saturation region
    slope, intercept, r_value, p_value, std_err = linregress(voltage_sat, current_sat)

    # Calculate Id_sat at the beginning of saturation
    Id_sat = current_sat[0]

    # Calculate lambda = slope / Id_sat
    lambda_value = slope / Id_sat

    return lambda_value, slope, Id_sat, r_value ** 2


def main():
    parser = argparse.ArgumentParser(description='Plot and analyze voltage-current data from CSV.')
    parser.add_argument('input_file', help='Input CSV file containing voltage-current data')
    parser.add_argument('--method', choices=['complex', 'basic'], default='complex',
                        help='Method to find saturation region')
    args = parser.parse_args()

    try:
        # Read CSV file
        data = pd.read_csv(args.input_file)
        voltage_mv = data['Voltage_mV'].values  # Already in mV
        current_ua = data['Current_uA'].values  # Already in µA
        voltage_v = voltage_mv / 1000.0  # Convert to V for calculations

        # Find saturation using selected method
        if args.method == 'complex':
            sat_idx = find_saturation_complex(voltage_mv, current_ua)
        else:
            sat_idx = find_saturation_basic(voltage_mv, current_ua)

        if np.isnan(sat_idx):
            print("No saturation region found!")
            return

        # Calculate lambda and related parameters
        lambda_value, slope, Id_sat, r_squared = calculate_lambda_from_saturation(
            voltage_v, current_ua, sat_idx)

        # Create figure
        plt.figure(figsize=(10, 6))

        # Plot I-V curve
        plt.plot(voltage_v, current_ua, 'b-', label='I-V Curve')

        # Mark saturation point
        plt.axvline(x=voltage_v[sat_idx], color='r', linestyle='--',
                    label=f'Saturation begins at {voltage_v[sat_idx]:.3f}V')

        # Plot fitted line in saturation region
        voltage_sat = voltage_v[sat_idx:]
        fitted_line = slope * voltage_sat + (Id_sat - slope * voltage_sat[0])
        plt.plot(voltage_sat, fitted_line, 'g--',
                 label=f'Fitted line (R² = {r_squared:.4f})')

        plt.grid(True)
        plt.xlabel('Voltage (V)')
        plt.ylabel('Current (µA)')
        plt.title('I-V Characteristic Curve with Saturation Region Fit')
        plt.legend()

        # Print results
        print(f"\nAnalysis Results:")
        print(f"Saturation begins at: {voltage_v[sat_idx]:.3f} V ({voltage_mv[sat_idx]:.1f} mV)")
        print(f"Current at saturation (Id_sat): {Id_sat:.2f} µA")
        print(f"\nSaturation Region Analysis:")
        print(f"Slope in saturation: {slope:.4f} µA/V")
        print(f"Lambda (λ = slope/Id_sat): {lambda_value:.6f} V⁻¹")
        print(f"Early voltage (VA = 1/λ): {1 / lambda_value:.2f} V")
        print(f"R-squared of fit: {r_squared:.4f}")

        plt.show()

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()