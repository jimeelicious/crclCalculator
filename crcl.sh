#!/bin/bash
debug=0
showwork=1
cutoffABWratio=1.2

### Color settings ###
GREEN='\033[7;32m'
NC='\033[0m'

### FUNCTIONS ###
greet() {
echo "-----------------------------------------"
echo "Serum creatinine calculator v1.4 by Jimmy"
echo "-----------------------------------------"
echo -e "Reminder: On dialysis? Don't calculate CrCl."
echo
}

promptInput() {
#prompt for height, weight, gender, and validates input
loop=1
while [ $loop = 1 ]; do read -p "Enter the age (years): " age
##	 if ! $(echo $age | grep -Poq '^[0-9]\d*$'); then
	if ! $(echo $age | perl -nle 'print if $t ||= m{^[0-9]\d*$} }{ exit 1 if !$t' &>/dev/null); then
	   echo "   Please enter the proper age. Press control + C to quit."; sleep 0.4
	else
	  loop=0
	fi
done



loop=1
while [ $loop = 1 ]; do read -p "Indicate if male or female (m/f): " gender
	if ! $(echo $gender | perl -nle 'print if $t ||= m{m|f} }{ exit 1 if !$t' &>/dev/null); then
	  echo "   Please enter either \"m\" or \"f\" only. Press control + C to quit."; sleep 0.4
	else
	  loop=0
	fi
done
if [ $gender = f ]; then
   genderFull=female
else
   genderFull=male
fi



loop=1
while [ $loop = 1 ]; do read -p "Enter the height (inches), or type \"cm\" to switch to centimeters mode: " height
        if ! $(echo $height | perl -nle 'print if $t ||= m{^[0-9]\d*(\.\d+)?$|^cm$} }{ exit 1 if !$t' &>/dev/null); then
          echo "   Please enter the proper height in inches, or type \"cm\" and hit enter"
          echo "   to change mode to centimeters." ; sleep 1

        elif [ $height = "cm" ]; then
          loop=2
          while [ $loop = 2 ]; do read -p "Enter the height (cm), or type \"in\" to switch to inches: " heightCM
            if ! $(echo $heightCM | perl -nle 'print if $t ||= m{^[0-9]\d*(\.\d+)?$|^in$} }{ exit 1 if !$t' &>/dev/null); then
              echo "   Please enter the proper height in centimeters, or"
	      echo "   type \"in\" and hit enter to change input to inches."; sleep 1
            elif [ $heightCM = "in" ]; then
              loop=1
            else
              heightCMraw=$(python -c "print $heightCM/2.54")
              height=$(python -c "print round($heightCMraw,2)")
              echo "   * Converted to $height inches ($heightCM centimeters)."
              loop=0
            fi
          done

        else
          loop=0
        fi
done

loop=1
while [ $loop = 1 ]; do read -p "Enter the weight (kilograms), or type \"lbs\" to switch to pounds: " TBW
        if ! $(echo $TBW | perl -nle 'print if $t ||= m{^[0-9]\d*(\.\d+)?$|^lbs$} }{ exit 1 if !$t' &>/dev/null); then
          echo "   Please enter the proper weight in kilograms. Type \"lbs\" and hit enter to change mode to pounds."; sleep 1

        elif [ $TBW = "lbs" ]; then
          loop=2
          while [ $loop = 2 ]; do read -p "Enter the weight (pounds), or type \"kgs\" to switch to kilograms: " TBWpounds
            if ! $(echo $TBWpounds | perl -nle 'print if $t ||= m{^[0-9]\d*(\.\d+)?$|^kgs$} }{ exit 1 if !$t' &>/dev/null); then
              echo "   Please enter the proper weight in pounds. Type "kgs" and hit enter to change mode to pounds."; sleep 1
            elif [ $TBWpounds = "kgs" ]; then
              loop=1
            else
              TBWraw=$(python -c "print $TBWpounds/2.20462")
              TBW=$(python -c "print round($TBWraw,2)")
              echo "   * Converted to $TBW kilograms ($TBWpounds pounds)."
              loop=0
            fi
          done

        else
          loop=0
        fi
done

loop=1
while [ $loop = 1 ]; do read -p "Enter in the serum creatinine (mg/dL): " scr
	if ! $(echo $scr | perl -nle 'print if $t ||= m{^[0-9]\d*(\.\d+)?$} }{ exit 1 if !$t' &>/dev/null); then
	  echo "   Please enter the serum creatinine in mg/dL. Press control + C to quit."; sleep 0.4
	else
	  loop=0
	fi
done
}




DetLowScr() {
# Determines if SCr needs to be 1 for patients older than 65 with SCr less than 1.0
scrOrig=$scr
scrChk=$(python -c "print int($scr)")
if [ $scrChk -lt 1 ] && [ $age -ge 65 ]; then
	scr=1
	echo "   * Rounded SCr to 1.0 because patient age >65 years old with a SCr of"
	echo "     $scrOrig < 1.0  (reduced geriatric muscle mass adjustment)."
	fi
}



CalcIBW() {
# If female, changes base weight at 60 inches to 45.5 kg
if [ $gender = f ]; then
   baseweight=45.5
   else baseweight=50
   fi

# Determines how many inches above 60 inches, then adds 2.3 kgs for every inch above 60 inches to get IBW.
heightdiff=$(python -c "print $height-60")
weightdiffadj=$(python -c "print 2.3*$heightdiff")
IBW=$(python -c "print $baseweight+$weightdiffadj")

## DEBUG FUNCTION
if [ $debug -eq 1 ]; then
	echo
	echo "Height diff in inches: $heightdiff"
	echo "Weight Difference Adj, added on to ideal BW at 5 feet: $weightdiffadj"
	fi

# Spit out output
if [ $showwork -eq 1 ]; then
  echo "IBW is $baseweight($gender) + 2.3*(Height-60) = $baseweight($gender) + 2.3*($height-60) = $IBW"
fi
}




DetWeightType() {
# Determines if overweight or underweight.
wtratio=$(python -c "print 100*$TBW/$IBW")
wtratioRound=$(python -c "print int($wtratio)")
cutoff=$(python -c "print int(100*$cutoffABWratio)")
wtratioDisplay=$(python -c "print round($TBW/$IBW,2)")
if [ $wtratioRound -ge "$cutoff" ]; then
	ABWflag=1
  elif [ $wtratioRound -lt 100 ]; then
	skinnyFlag=1
	echo "   * Using total body weight because the patient's TBW/IBW ratio is ${wtratioDisplay} < 1"
  fi

## DEBUG FUNCTION
if [ $debug -eq 1 ]; then
	echo
	echo "Weight ratio? $wtratio"
	echo "Weight ratio Rounded? $wtratioRound"
	echo "ABW flag set? $ABWflag"
	echo "Underweight flag set? $skinnyFlag"
	fi
}



GetABW(){
# Calculates ABW. Finds difference between TBW, IBW first, then multiplies by 0.4 adjustment.
TBWIBWdiff=$(python -c "print $TBW-$IBW")
ABW=$(python -c "print 0.4*$TBWIBWdiff+$IBW")
wtratioDisplay=$(python -c "print round($TBW/$IBW,2)")

## DEBUG FUNCTION
if [ $debug -eq 1 ]; then
	echo
	echo "TBW-IBW difference in kilograms: $TBWIBWdiff"
	fi

# Calculates final ABW result by adding above result
if [ $showwork -eq 1 ]; then
echo "   * ABW is used because the patient's TBW/IBW ratio is $wtratioDisplay > ${cutoffABWratio}"
echo "ABW = IBW + 0.4*(TBW-IBW) = $IBW + 0.4*($TBW-$IBW) = $ABW"
fi
}



CalculateCrCl() {
# Sets either the adjusted, ideal, or total body weight to be used
if [ "$ABWflag" = 1 ]; then
	EqnWt=$ABW
  elif [ "$skinnyFlag" = 1 ]; then
	EqnWt=$TBW
  else
	EqnWt=$IBW
  fi

### CrCl Equation
# Calculates the numerator
num=$(python -c "print (140-$age)*$EqnWt")
# Calculates the denominator
den=$(python -c "print 72*$scr")
# Divides
CrCl=$(python -c "print $num/$den")
# If female, multiply final result by 0.85
if [ $gender = f ]; then
	CrClFinal=$(python -c "print $CrCl*0.85")
  else
	CrClFinal=$CrCl
  fi
CrCl=$(python -c "print round($CrCl,1)")
CrClFinal=$(python -c "print round($CrClFinal,1)")
### End CrCl Equation

# Spits out answer, showing work if requested.
echo
if [ $showwork -eq 1 ]; then
	echo "CrCl = [(140-age)*weight] / (72*SCr) = [(140-${age})*${EqnWt}] / (72*${scr}) = $CrCl"
	if [ $gender = f ]; then
	  echo "Female patient, thus multiply by 0.85: (${CrCl})*(0.85) = $CrClFinal"
	fi
fi
echo -e The estimated creatinine clearance is ${GREEN}$CrClFinal mL\/min${NC} \($genderFull\).
echo
ABWflag=0
skinnyFlag=0

## DEBUG FUNCTION
if [ $debug -eq 1 ]; then
	echo
	echo "Equation Weight used: $EqnWt"
	echo "Equation NUMERATOR used: $num"
	echo "Equation DEMOMINATOR used: $den"
	fi
}



### SCRIPT ###
greet
while true; do
  promptInput
  DetLowScr
  CalcIBW
  DetWeightType
  if [ "$ABWflag" = 1 ]; then
	GetABW
	fi
  CalculateCrCl
done
