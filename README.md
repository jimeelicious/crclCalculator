# INTRODUCTION
This is an offline creatinine clearance calculator to help those on acute care rotations. 
It automatically determines which weight to use (adjusted, ideal, total), multiplies the result
by 0.85 if female, and accounts for reduced geriatric muscle mass when serum creatinine is less than
1.0 and when the patient is older than 65 years old.

The code works for MacOS and Linux, but I am finding a way to make it available on Windows, which will come sometime later. This uses the Cockcroft-Gault Equation to estimate the renal function.

![(Program when ran](img/run.png)

After entering in parameters:
![After entering in parameters](img/result.PNG)

### Important Disclaimer
This code was written to assist, not definitely determine, a person's renal clearance. In other words, it should not solely be used to estimate renal function. In a clinical setting, one **must** manually recheck these calculations.

**_Why?_** SCr is a *lagging* lab measurement reflective of the patient's state approximately 2-3 days from the present. It is imperative that one's clinical judgment must be used when determining the appropriate dosage adjustment for a patient, keeping in mind of renal function trends and current state.

The best, most-current, renal function status would be reflected by the urine output (UOP) in the labs.

See the original paper for the Cockcroft-Gault equation:
> Cockcroft DW, Gault MH. Prediction of creatinine clearance from serum creatinine. Nephron. 1976;16(1):31-41.
> doi:10.1159/000180580.


# INSTALLATION
### <img src="http://icons.iconarchive.com/icons/icons8/windows-8/256/Systems-Mac-Os-icon.png" width="20">   Macintosh
1. `COMMAND` + `SPACE` from the desktop to open Spotlight, then type **terminal** and hit `Enter` to open terminal.

2. Copy and paste this code in terminal, and hit enter:
```
curl -L https://goo.gl/9tVe59 -o ~/Desktop/CrCl.command && chmod u+x ~/Desktop/CrCl.command
```

3. **That's it!** It's on your desktop now. You can move this file to your "Applications" folder or anywhere you'd like.

### <img src="https://cdn4.iconfinder.com/data/icons/proglyphs-free/512/Linux_-_Tux-128.png" width="20">   Linux
1. Fire up terminal shell with `CONTROL` + `ALT` + `T`.

2. Copy and paste this code in terminal, and hit enter:
```
curl -L https://goo.gl/9tVe59 -o ~/crcl.sh && chmod u+x ~/crcl.sh
```

3. You're all set! It's on your home directory. To run, open a terminal window and type `~/crcl.sh`.

# RUNNING THE PROGRAM
To run, click the icon on your desktop.

### Stopping the program
You may close the terminal window at any time to stop the program.

# UNINSTALLING OR DELETING THE PROGRAM
Simply delete the file on your desktop.


### Technical Details
The calculator uses the total body weight when less than ideal. It also uses adjusted body weight when TBW/IBW ratio is more than 1.2.

To change this to another setting for example 1.3, you can use any text editor (Notepad, etc.) and edit the code's first section where it says `cutoffABWratio=1.2`
and changing it to `cutoffABWratio=1.3`.
 
 
It is also set to show its work by default, but this setting can be changed by changing `showwork=1` to `showwork=0` in the same area. I don't recommend this because forgetting how to manually calculate the renal function is never a good thing.

View the source code [here](https://github.com/jimeelicious/creatineCalculator/blob/master/crcl.sh). This program assumes Python, Bash, and cURL are installed.

#### Acknowledgements
- **Dr. Adrian Palisoc, PharmD.**
For his contribution in providing crucial clinical pearls that led to the creation of the disclaimer.
