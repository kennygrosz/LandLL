import sklearn
from sklearn import svm
import xlrd
import os
import csv
import pandas as pd
cwd = os.getcwd()

fileName = '/Features/features_mega_matrix.xlsx'
path = cwd+fileName

dat = pd.read_csv(path,error_bad_lines=False)



#dataframe = xlrd.open_workbook(path)


X = [[0, 0, 0], [1, 1, 1]]
y = [0, 1]
#clf = svm.SVC()
#clf.fit(X, y)

#print(clf.predict([[2., 2.,2.],[0,0,0],[1.9,1.9,1.9],[0.2,0.4,0.3]]))
