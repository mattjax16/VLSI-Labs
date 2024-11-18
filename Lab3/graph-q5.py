import numpy as np
import matplotlib.pyplot as plt

vdd = np.array([0.5, 0.6, 0.7, 0.8, 0.9, 1.05])
tphl = np.array([63.9342, 34.2668, 23.7793, 19.2263, 16.4486, 13.5281])
tplh = np.array([67.4436, 33.5265, 22.5813, 17.0160, 14.2860, 12.0161])

tp = (tphl + tplh) / 2

plt.figure(figsize=(10, 6))

plt.plot(vdd, tp, 'bo-', linewidth=2, markersize=8, label='Average Delay (Tp)')

plt.grid(True, linestyle='--', alpha=0.7)
plt.xlabel('Source Voltage (Vdd)', fontsize=12)
plt.ylabel('Average Propagation Delay, Tp (ps)', fontsize=12)
plt.title('Average Inverter Propagation Delay (Tp) vs Supply Voltage (Vdd)', fontsize=14)

# Set x-axis ticks
x_ticks = np.arange(0.5, 1.06, 0.05)
plt.xticks(x_ticks)

# Set y-axis ticks from 0 to 70 in steps of 10
plt.ylim(0, 70)
y_ticks = np.arange(0, 71, 10)
plt.yticks(y_ticks)

# Add data point labels
for i, (x, y) in enumerate(zip(vdd, tp)):
  if i == 0:
      plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points",
                  xytext=(10,0), ha='left')
  elif i == len(vdd)-1:
      plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points",
                  xytext=(-15,10), ha='center')
  else:
      plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points",
                  xytext=(10,10), ha='left')

plt.tight_layout()
plt.savefig('inverter_delay-q5.png', dpi=300, bbox_inches='tight')
plt.show()

print("\nNumerical Results:")
print("Vdd (V) | TPHL (ps) | TPLH (ps) | TP (ps)")
print("-" * 45)
for v, hl, lh, p in zip(vdd, tphl, tplh, tp):
  print(f"{v:7.2f} | {hl:8.2f} | {lh:8.2f} | {p:6.2f}")