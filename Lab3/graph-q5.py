import numpy as np
import matplotlib.pyplot as plt

# Data from your HSPICE output
vdd = np.array([0.5, 0.6, 0.7, 0.8, 0.9, 1.05])  # Supply voltage in V
tphl = np.array([63.9342, 34.2668, 23.7793, 19.2263, 16.4486, 13.5281])  # High-to-Low delay in ps
tplh = np.array([67.4436, 33.5265, 22.5813, 17.0160, 14.2860, 12.0161])  # Low-to-High delay in ps

# Calculate average propagation delay (Tp)
tp = (tphl + tplh) / 2

# Create the plot
plt.figure(figsize=(10, 6))
plt.plot(vdd, tp, 'bo-', linewidth=2, markersize=8, label='Average Delay (Tp)')

# Add grid and labels
plt.grid(True, linestyle='--', alpha=0.7)
plt.xlabel('Supply Voltage (V)', fontsize=12)
plt.ylabel('Average Propagation Delay, Tp (ps)', fontsize=12)
plt.title('Inverter Propagation Delay vs Supply Voltage', fontsize=14)

# Add data point labels
for i, (x, y) in enumerate(zip(vdd, tp)):
    plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points", 
                xytext=(0,10), ha='center')

# Add a table with the exact values
table_data = [
    [f'{v:.2f}V' for v in vdd],
    [f'{t:.2f}ps' for t in tp]
]
plt.table(cellText=[table_data[1]], 
         colLabels=table_data[0],
         loc='bottom',
         bbox=[0, -0.35, 1, 0.2])

# Adjust layout to prevent label clipping
plt.subplots_adjust(bottom=0.25)

# Add legend
plt.legend()

plt.savefig('inverter_delay.png', dpi=300, bbox_inches='tight')
plt.show()

# Print numerical results
print("\nNumerical Results:")
print("VDD (V) | TPHL (ps) | TPLH (ps) | TP (ps)")
print("-" * 45)
for v, hl, lh, p in zip(vdd, tphl, tplh, tp):
    print(f"{v:7.2f} | {hl:8.2f} | {lh:8.2f} | {p:6.2f}")