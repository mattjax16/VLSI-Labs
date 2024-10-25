import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.signal import savgol_filter
from scipy.stats import linregress
import argparse


def find_saturation_complex(voltage, current_ua, window_size=21, threshold=0.05):
    """
    Complex method uses smoothed derivatives to reduce noise sensitivity.
    Current is expected in microamps.
    """
    try:
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
            return zero_indices[0], gm_smooth, gm2_smooth, normalized_gm2
        else:
            return np.nan, gm_smooth, gm2_smooth, normalized_gm2
    except:
        return np.nan, None, None, None


def find_saturation_basic(voltage, current_ua, threshold=0.05):
    """
    Basic method uses direct derivatives without smoothing.
    Current is expected in microamps.

    Args:
        threshold: relative threshold (0.05 = 5% of max second derivative)
    """
    try:
        # First derivative
        first_derivative = np.gradient(current_ua, voltage)

        # Second derivative
        second_derivative = np.gradient(first_derivative, voltage)

        # Normalize second derivative like in complex method
        normalized_second_derivative = np.abs(second_derivative) / np.max(np.abs(second_derivative))
        zero_indices = np.where(normalized_second_derivative < threshold)[0]

        if len(zero_indices) > 0:
            return zero_indices[0], first_derivative, normalized_second_derivative
        else:
            return np.nan, first_derivative, normalized_second_derivative
    except:
        return np.nan, None, None


def plot_derivatives(voltage, current_ua, method_results, method='complex'):
    """Plot derivatives to understand saturation detection"""
    if method == 'complex':
        sat_idx, gm_smooth, gm2_smooth, normalized_gm2 = method_results

        fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 12))

        # Plot smoothed first derivative
        ax1.plot(voltage, gm_smooth)
        ax1.set_title('Smoothed First Derivative (Transconductance)')
        ax1.set_xlabel('Voltage (V)')
        ax1.set_ylabel('dI/dV (µA/V)')
        ax1.grid(True)

        # Plot smoothed second derivative
        ax2.plot(voltage, gm2_smooth)
        ax2.set_title('Smoothed Second Derivative')
        ax2.set_xlabel('Voltage (V)')
        ax2.set_ylabel('d²I/dV² (µA/V²)')
        ax2.grid(True)

        # Plot normalized second derivative
        ax3.plot(voltage, normalized_gm2)
        ax3.axhline(y=0.05, color='r', linestyle='--', label='Threshold')
        if not np.isnan(sat_idx):
            ax3.axvline(x=voltage[sat_idx], color='g', linestyle='--', label='Saturation Point')
        ax3.set_title('Normalized Second Derivative')
        ax3.set_xlabel('Voltage (V)')
        ax3.set_ylabel('Normalized d²I/dV²')
        ax3.legend()
        ax3.grid(True)

    else:
        sat_idx, first_derivative, second_derivative = method_results

        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))

        # Plot first derivative
        ax1.plot(voltage, first_derivative)
        ax1.set_title('First Derivative (Transconductance)')
        ax1.set_xlabel('Voltage (V)')
        ax1.set_ylabel('dI/dV (µA/V)')
        ax1.grid(True)

        # Plot second derivative
        ax2.plot(voltage, second_derivative)
        ax2.axhline(y=0.01, color='r', linestyle='--', label='Threshold')
        ax2.axhline(y=-0.01, color='r', linestyle='--')
        if not np.isnan(sat_idx):
            ax2.axvline(x=voltage[sat_idx], color='g', linestyle='--', label='Saturation Point')
        ax2.set_title('Second Derivative')
        ax2.set_xlabel('Voltage (V)')
        ax2.set_ylabel('d²I/dV² (µA/V²)')
        ax2.legend()
        ax2.grid(True)

    plt.tight_layout()
    return fig


def main():
    parser = argparse.ArgumentParser(description='Plot and analyze voltage-current data from CSV.')
    parser.add_argument('input_file', help='Input CSV file containing voltage-current data')
    parser.add_argument('--method', choices=['complex', 'basic'], default='complex',
                        help='Method to find saturation region')
    args = parser.parse_args()

    try:
        # Read CSV file
        data = pd.read_csv(args.input_file)
        voltage = data['voltage'].values
        # Convert current to microamps immediately
        current_ua = data['current'].values * 1e6

        # Find saturation using selected method
        if args.method == 'complex':
            sat_results = find_saturation_complex(voltage, current_ua)
            sat_idx = sat_results[0]
        else:
            sat_results = find_saturation_basic(voltage, current_ua)
            sat_idx = sat_results[0]

        # Plot derivatives for chosen method
        plot_derivatives(voltage, current_ua, sat_results, method=args.method)

        # Plot I-V curve
        plt.figure(figsize=(10, 6))
        plt.plot(voltage, current_ua, 'b-', label='I-V Curve')
        if not np.isnan(sat_idx):
            plt.axvline(x=voltage[sat_idx], color='r', linestyle='--',
                        label=f'Saturation begins at {voltage[sat_idx]:.3f}V')
        plt.grid(True)
        plt.xlabel('Voltage (V)')
        plt.ylabel('Current (µA)')
        plt.title(f'I-V Characteristic Curve ({args.method} method)')
        plt.legend()

        # Print results
        print(f"\nAnalysis Results:")
        if np.isnan(sat_idx):
            print("No saturation region found!")
        else:
            print(f"Saturation begins at: {voltage[sat_idx]:.3f} V")
            print(f"Current at saturation: {current_ua[sat_idx]:.2f} µA")

            # Calculate linear fit parameters in saturation region
            slope, intercept, r_value, _, _ = linregress(
                voltage[sat_idx:], current_ua[sat_idx:])
            print(f"Linear fit in saturation region:")
            print(f"Slope (conductance): {slope:.2f} µA/V")
            print(f"R-squared value: {r_value ** 2:.4f}")

        plt.show()

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()