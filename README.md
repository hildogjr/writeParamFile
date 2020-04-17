# Description
`writeParamFile` Matlab function that writes a parameter file compatible with C/C++ and Python language. The file is populated with the values the mentioned variables of the base workspace.


# Cite as
Guillardi Jr., Hildo (2020). writeParamFile (https://www.github.com/hildogjr/writeParamFile), GitHub. Retrieved April 17, 2020.


# Usage
My personal use of this function is export configuration to  DSP C/C++ softwares and PSIM simulations (.txt extesion).

- Opening at the use
```
writeParamFile fileName 'Description group one' var1 var2 var3 ... 'Description group two' ...
writeParamFile % At the end to close the opened file
```

- Opening jsut one time
```
writeParamFile fileName
writeParamFile 'Description group three' matrix1 ...
writeParamFile 'Description group four' matrix2 ...
writeParamFile % At the end to close the opened file.
```

The open file command should be used just one, a sequential script e.g.:

```
writeParamFile fileName
writeParamFile var1 '\\ Description of this variable.'
writeParamFile 'Description group one' var1 var2 var3
```

The decriptions are add as a general header group. To add a comment by line usethe bellow examples. The first input (file name) may or may not  be used.

```
writeParamFile '\\ Description.'
writeParamFile var1 '\\ Description of this variable.'
...
```
