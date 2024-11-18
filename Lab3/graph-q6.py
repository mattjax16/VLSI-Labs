import numpy as np
import matplotlib.pyplot as plt

widths_nmos = np.array([300, 600, 900, 1200, 1500, 1800])
widths_pmos = widths_nmos * 2
tp = np.array([(34.5683 + 29.9519)/2, (22.7602 + 19.2171)/2,
              (19.4498 + 15.9661)/2, (17.6897 + 14.5125)/2,
              (16.5475 + 13.5729)/2, (15.7501 + 12.9448)/2])

fig, ax1 = plt.subplots(figsize=(10, 6))

# Plot on primary axis (NMOS)
ax1.plot(widths_nmos, tp, 'bo-', linewidth=2, markersize=8)
ax1.set_xlabel('NMOS Width (nm)', color='blue')
ax1.set_ylabel('Tp (ps)')
ax1.tick_params(axis='x', labelcolor='blue')
ax1.set_xticks(widths_nmos)
ax1.set_ylim(0, 35)
ax1.set_yticks(np.arange(0, 36, 2))

# Create secondary x-axis with shared ticks (PMOS)
ax2 = ax1.twiny()
ax2.set_xlim(ax1.get_xlim())
ax2.set_xticks(widths_nmos)
ax2.set_xticklabels([str(int(w*2)) for w in widths_nmos])
ax2.set_xlabel('PMOS Width (nm)', color='red')
ax2.tick_params(axis='x', labelcolor='red')

# Add major gridlines from y-axis ticks
ax1.yaxis.grid(True, linestyle='-', alpha=0.7)
ax1.xaxis.grid(True, linestyle='-', alpha=0.7)
ax1.set_axisbelow(True)

plt.title('Propagation Delay (Tp) vs Transistor Widths of Balanced Inverter (w_p, w_n)')

# Add data point labels with different offsets
for i, (x, y) in enumerate(zip(widths_nmos, tp)):
   if i == 0:  # First point
       plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points", xytext=(10,0), ha='left')
   elif i == len(widths_nmos)-1:  # Last point
       plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points", xytext=(0,10), ha='right')
   else:  # Middle points
       plt.annotate(f'{y:.2f} ps', (x, y), textcoords="offset points", xytext=(10,10), ha='left')

plt.tight_layout()
plt.savefig('inverter_delay-q6.png', dpi=300, bbox_inches='tight')
plt.show()