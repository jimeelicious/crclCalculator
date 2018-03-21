# INTRO
This is an offline creatinine clearance calculator program to help those on acute care rotations. It determines which weight to use (adjusted, ideal, total) automatically based on what was taught in Track 4.
The code works for MacOS and Linux, but I am finding a way to make it available on Windows, which will come sometime later. This uses the Cockcroft-Gault Equation to estimate the renal function.

![(Program when ran](img/run.png)

After entering in parameters:
![After entering in parameters](img/result.PNG)

View the source code here [here](https://github.com/jimeelicious/creatineCalculator/blob/master/crcl.sh).


More information on using serum creatine as an estimate of renal function, see this journal for more details.
> Cockcroft DW, Gault MH. Prediction of creatinine clearance from serum creatinine. Nephron. 1976;16(1):31-41.
> DOI: 10.1159/000180580

# INSTALLATION (from MacOS or Linux)

`COMMAND` + `SPACE` from the desktop to open Spotlight, then type "terminal" to open terminal.

Then copy and paste this code and hit enter:
```
curl -L https://goo.gl/69wtMR -o ~/crcl.sh && chmod +x ~/crcl.sh
```


# RUNNING THE PROGRAM
To run, open terminal from your Mac, then type and run this command: 
```
~/crcl.sh
```

### Stopping the program
To stop, press the `Control` + `C` keys any time.

# UNINSTALLING OR DELETING THE PROGRAM
Simply delete the file crcr.sh. Or open terminal, and run this command:
```
rm -i ~/crcl.sh
```


### TECHNICAL JARGON
The calculator uses the total body weight when less than ideal. It also uses adjusted body weight when TBW/IBW ratio is more than 1.2.

To change this to another setting for example 1.3, you can use any text editor (Notepad, etc.) and edit the code's first section where it says `cutoffABWratio=1.2`
and changing it to `cutoffABWratio=1.3`.
 
 
It is also set to show its work by default, but this setting can be changed by changing `showwork=1` to `showwork=0` in the same area. I don't recommend this because forgetting how to manually calculate the renal function is never a good thing.

Furthermore, this program assumes Python, Bash, and cURL are installed.
