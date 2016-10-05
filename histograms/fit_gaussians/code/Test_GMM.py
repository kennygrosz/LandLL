import numpy as np
from sklearn import mixture
import csv
from matplotlib import pyplot as plt
with open('C:\Users\kenny\Desktop\CAAM 495 - Senior Design\LandLL\histograms\code\histogram_2.csv') as histfile:
    histdata = csv.reader(histfile)
    intensities = []
    frequencies = []
    histogram = []
    for row in histdata:
        #if int(row[0]) > -500:  <-- Use this line of code to block out noise
            #histogram.append([float(i) for i in row])
            intensities.append(float(row[0]))
            #frequencies.append(float(row[1]))
n=len(intensities)
x = np.asarray(intensities, order='F').reshape(n,1)
#plt.hist(myarray,bins=256)
#plt.show()
print x
gmm = mixture.GMM(n_components=2) # gmm for two components
gmm.fit(x) # train it

print gmm

# linspace = np.linspace(-10, 10, 1000)
#
# fig, ax1 = plt.subplots()
# ax2 = ax1.twinx()
#
# ax1.hist(x, 100) # draw samples
# ax2.plot(linspace, np.exp(gmm.score_samples(linspace)[0]), 'r') # draw GMM
# plt.show()




# import numpy as np
# from sklearn import mixture
# import matplotlib.pyplot as plt
# import csv
# from matplotlib import pyplot as plt
# with open('C:\Users\kenny\Desktop\Caam 495 - Senior Design\LandLL\histograms\code\histogram_2.csv') as histfile:
#
#     histdata = csv.reader(histfile)
#     intensities = np.empty([1])
#     #frequencies = np.empty([1])
#     histogram = []
#
#     for row in histdata:
#         #if int(row[0]) > -500:  <-- Use this line of code to block out noise
#             histogram.append([float(i) for i in row])
#             intensities = np.append(intensities, float(row[0]))
#             #frequencies = np.append(frequencies, float(row[1]))
#
#             # intensities.append(float(row[0]))
#             #frequencies.append(float(row[1]))
#
# #plt.hist(intensities,bins=256,weights=frequencies)
# #plt.show()
# #obs = np.concatenate((np.random.randn(100, 1),10 + np.random.randn(300, 1)))
#
# #print obs
#
# print intensities[1:10]
#
# gmm = mixture.GMM(n_components=2)  # gmm for two components
# gmm.fit(intensities)
#
# print(gmm)