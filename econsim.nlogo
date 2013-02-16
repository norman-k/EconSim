breed [persons person]
breed [corporations corporation]
breed [banks bank]
breed [national_banks national_bank]
breed [houses house]
turtles-own [capital funding workers wage price supply state inflation bank_rate firm_spent person_spent dividents bank_employers capital_gains dividends]
globals[fed bond]

to startup ;special procedure in netlogo that runs whatever code you put here automatically when the .nlogo file is opened
end

to setup
  ca
  set fed [1]
  reset-timer
  create-corporations 10
         [set shape "corporation"
          set funding 100
          set_funding
          set workers 4
          set size 5
          setxy random-xcor random-ycor
          set heading 0
          set price 5.00
          set supply 1000 * (count corporations)
         ]
  create-persons 50 
         [set shape "person"
          set_capital
         ]
   create-banks 2
         [set shape "bank"
          set funding ((capital * ((count persons) / 2)) / 10)
          set size 0
          setxy random-xcor random-ycor
          set bank_rate 2
          set capital_gains required_reserve_ratio * 10
          set dividends funding / (capital_gains + 0.01)
         ]

   ask turtles[setup-plots]
end
to go
  
  ;ask persons[face]
  ask turtles[setup-plots
  if price < equilibrium_price[
  set price price + 0.1
  ]
  if price > equilibrium_price[
  set price price - 0.1
  ]
  if supply < equilibrium_quantity[
    set supply supply + 0.1
  ]
  if supply > equilibrium_quantity[
    set supply supply - 0.1
  ]
  ]
  ask persons[set_capital]
  let h []
  let j []
  ask corporations[set h fput xcor h]
  ask corporations[set j fput ycor j]
  ask corporations[if funding > 1000[ask persons[setxy item random(length h) h item random(length j) j]]]
  ask corporations[ask persons in-radius 3[set state "working"]]
  ask persons[if state != "working"[set capital 0]]
  ask persons[if capital < 2[set state "unemployed" setxy random-xcor random-ycor]]
  ask persons[if funding < 2000[if random(1) > 0[set state "unemployed" setxy random-xcor random-ycor]]]
  ask persons[if capital > lb_threshold and capital < mb_threshold[set capital 
  capital - (lb_income_tax_rates * capital)]]
  ask persons[if capital >= mb_threshold and capital <= hb_threshold[set capital capital - (lb_income_tax_rates * capital)]]
  ask persons[if capital > hb_threshold[set capital capital - (lb_income_tax_rates * capital)]]

  ;every 5[create-persons 50 
  ;       [set shape "person"
  ;        set_wage
  ;        set capital wage
  ;       ]
  ;]
end
to free_bank
  set corporate_tax_rates 0
  set set_stimulus 0 
end
to abolish_fed
  set fed []
end
to-report average_capital
  let h []
  ask persons[set h fput capital h]
  report mean h
end
to-report equilibrium_price; ((a - c) / (b + d))
  let a price + (average_capital / 100)
  let b 1.75 ; elastic
  let f price - (average_capital / 100)
  let d 1.75 ; elastic
  let p ((a - f) / (b + d))
  ifelse p <= 0[report (p + (b))][
  report p]
end
to-report equilibrium_quantity; (ad + bf/(b + d))
  let a price + (average_capital / 100)
  let b 1.75 ; elastic
  let f price - (average_capital / 100)
  let d 1.75 ; elastic
  let p ((a * d + b * f)/(b + d))
  report p
end
to-report demand_curve; P = a - bQd a is the highest price anyone would pay(reservation pay; remember paying anything less is a consumer surplus for the buyer which is (reservation price - market price)) and b is the slope (P = 0)
  let a price + (average_capital / 100)
  let b 1.75 ; elastic
  let d a / b
  report d
end
to-report supply_curve; P = a - bQs a is the lowest price anyone would sell and b is the slope (p = 0)
  let a price - (average_capital / 100)
  let b 1.75 ; elastic
  let d a / b
  report d
end
to-report demand
  report price
end
to wiggle
  fd 5
  rt 15
  lt 15
end
to stimulus
  ask turtles[
    set capital capital + (set_stimulus)
;    ]
;    every 3[set capital capital - (set_stimulus / 2.5)
;                  set price price - 2
;                  set entitlement_spending entitlement_spending - 10
;    ]
;  ]
  ]
  ;add: increases the inflation rate to 5%, and increases capital, along with workers. But lowers wage and after 7 seconds inflation and worker increase stops and GDP goes down.
end
to gold
  set inflation inflation_rate + 0.25 set price price + 0.25
  
  ;reduces inflation rate/increase in percentage of capital to 0.25% from 2%
end
to austerity
   ask turtles[
     if entitlement_spending > 1[set entitlement_spending ((%_gov_cuts / 100) * entitlement_spending)]
     if entitlement_spending < 1[set entitlement_spending 0]
   ] 
;    if timer < 7[set capital capital - 5
;                 set price price - 1
;                 set entitlement_spending entitlement_spending - 10
;    ]
;    if timer >= 7[set capital capital + 6
;                  set price price + 2
;                  set entitlement_spending entitlement_spending + 4
;    ]
;  ]
  ;lowers government spending and raises tax rates
end
to nit
  ask persons[if capital < lb_threshold[set lb_income_tax_rates 0]
  if capital >= lb_threshold / 10 and capital <= mb_threshold[set lb_income_tax_rates 5]]
end
to deregulate
  ;lowers corporate tax 2% every year for 10 years and gets rid of cap on recapitalization limits and lowers mininum wage to $5.50
end
to regulate
  ;hightens corporate tax 2% every year for 10 years sets limit to 1 company and has a mininum wage of $10
end
to recapitalize
  ask corporations[if funding <= 1000[set state "bankrupt"]
   if state = "bankrupt"[
      die 
   ask corporation 0[
      set funding funding + 1000
   ]
   ]
  ]
      create-corporations 1
         [set shape "corporation"
          set funding 100
          set_funding
          set workers 4
          set size 5
          setxy random-xcor random-ycor
          set price 5.00
          set supply 1000 * (count corporations)
         ]
   
  
  
end
to-report unemployment_rate
     report ((count persons with[ capital < 2.5]) / (count turtles) * 100)
end
to set_capital
  ifelse random(50) > 40
     [set capital mininum_wage + 20]
     [ifelse random(50) > 5
       [set capital mininum_wage]
       [set capital 0]
     ]
end
to-report number_lb_people
  report count persons with[ capital > lb_threshold and capital < mb_threshold]
end
to-report number_mb_people
  report count persons with[ capital > mb_threshold and capital < hb_threshold]
end
to-report number_hb_people
  report count persons with[ capital > hb_threshold]
end
to-report tax_revenue
  report (lb_income_tax_rates * number_lb_people) + (mb_income_tax_rates * number_mb_people) + (hb_income_tax_rates * number_hb_people) + (corporate_tax_rates * count corporations) + (capital_gains_tax_rates * count persons)
end
to-report deficit
  let q 0
  set q (entitlement_spending - tax_revenue)
  report q
end
to-report debt
  let q 0
  let h deficit
  every 2[set q h] 
  report q
end
to-report inflation_rate
  let A price; price
  let B price + 2; CPI
  report ((( B - A) / (A + 1.01)) * 100)
end
to-report CPI ;Consumer_Price_Index
  report price + 2; not correct value
end
to-report aggregate_capital
  report ((capital * count persons) - ((lb_income_tax_rates * number_lb_people) + (mb_income_tax_rates * number_mb_people) + (hb_income_tax_rates * number_hb_people) + (capital_gains_tax_rates * count persons)))
end     

to-report C ;private_consumption or C = C0 + C1((y)^d) where c0 is autonomous spending if income levels were zero c1 is the marginal propensity to consume
  report ((total_saving - total_borrowing) * count persons) + (MPC * aggregate_capital)
end
to-report M
  report (supply * price)
end  
to-report Government_spending
    report entitlement_spending 
end
to-report total_borrowing
  report capital
end
to-report total_saving
  report capital / 50
end
to-report total_income
  report aggregate_capital
end
;to-report MPC ;marginal propensity to consume
;   report change_in_consumption / change_in_income
;end
;to-report change_in_consumption
;  let h ((aggregate_capital) / (5 * 50))
;  report h
;end
to-report change_in_savings
  let h (total_saving * ((count persons) + 1))
  if timer <= 4[
     report h]
  
  if timer > 5[let z ((total_saving * ((count persons) + 1)) - h)
    report z]
  let z (total_saving * ((((count persons) + 1)) - h))
    report z
end
to-report change_in_income
  let h (aggregate_capital * ((count persons) + 1))
  if timer <= 5[
     report h]
  
  if timer > 5[let z ((aggregate_capital * ((count persons) + 1)) - h)
    report z]
  let z (total_saving * (((aggregate_capital * ((count persons) + 1)) - h)))
    report z
end
to-report MPS; slope of savings schedule
  report change_in_savings / (change_in_income + .000000001)
end
to-report MPC; slope of consumption schedule
  report (1 - MPS)
end
;to-report GDP
to-report aggregate_firm_spent
  report ((capital * count corporations) + 1) / 40
end
to-report aggregate_person_spent
  report ((capital * count persons) + 1) / 40
end
to-report invest_per_person
  report 1
  ;report random(capital)
end
to-report I
  report aggregate_firm_spent + aggregate_person_spent + invest_per_person
end
to-report G
  report entitlement_spending
end 
to set_funding
   ask corporations[ifelse random(50) > 40
     [set funding 100000]
     [ifelse random(50) > 5
       [set funding 50000]
       [set funding 10000]
     ]]
end
to-report money_multiplier
  report (1 / required_reserve_ratio)
end
to-report M1
  ask turtles[report (aggregate_capital + capital_gains)]
end
to-report M2
  ask turtles[report M1 + dividends]
end
to-report M3
  ask turtles[report M2 + capital] ; fix to reflect large deposits
end
to-report aggregate_supply; Y = Y* + α·(P-Pe)
  let y (C + G + I)
    let a 0.6
    let P price
    let Pj equilibrium_price
    report (y + a * (P - Pj))
end
to-report compensation_of_employees
  report aggregate_capital
end
to-report rents
  report (capital / 2)
end
to-report interest
  report Fed_interest_rates
end
to-report corporate_profits
  report corporate_tax_rates + (dividends * (count banks)) + funding
end
to-report GDP_income_approach
  ask turtles[report Compensation_of_employees + Rents + Interest + Corporate_profits]
end
to-report national_income
  report 0
end
to-report personal_income
  report 0
end
to-report domestic_income
  report 0
end
@#$#@#$#@
GRAPHICS-WINDOW
211
11
650
471
16
16
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
658
102
812
135
Nationalize the Banks!
stimulus
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
51
271
115
304
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
51
321
114
354
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
660
48
809
97
Keynesian:\nRemember, in the long run we're all dead!
12
0.0
1

TEXTBOX
881
48
1031
78
Monetarist:\nInvest in Gold!
12
0.0
1

BUTTON
876
79
988
112
Hard Currency
ask turtles[gold]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
835
337
1074
487
Phillips Curve
Unemployment Rate
Inflation Rate
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range  min-pycor max-pycor" ""
PENS
"Unemp." 1.0 0 -5298144 true "ask turtles[plot unemployment_rate]" "ask turtles[plot unemployment_rate]"
"Inflat." 1.0 0 -15582384 true "ask turtles[plot inflation_rate]" "ask turtles[plot inflation_rate]"

PLOT
1227
705
1455
855
IS/LM
GDP
Interest Rates
0.0
15.0
0.0
15.0
true
true
"set-plot-y-range  min-pycor max-pycor" ""
PENS
"GDP" 1.0 0 -5298144 true "ask turtles[plot C + G + I]" "ask turtles[plot C + G + I]"
"IR" 1.0 0 -14454117 true "ask turtles[plotxy fed_interest_rates (C + G + I) ]" "ask turtles[plotxy fed_interest_rates (C + G + I) ]"

SLIDER
11
184
195
217
corporate_tax_rates
corporate_tax_rates
0
100
100
1
1
NIL
HORIZONTAL

PLOT
1264
341
1498
491
Laffer Curve
Tax Revenue
Tax Rate
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range  min-pycor max-pycor" ""
PENS
"rev." 1.0 0 -5298144 true "plot tax_revenue" "plot tax_revenue"
"rate" 1.0 0 -14985354 true "plot lb_income_tax_rates" "plot lb_income_tax_rates"

BUTTON
656
277
811
312
Austerity
austerity
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
874
196
1045
229
Negative Income Tax
nit
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1076
94
1276
244
Price of Products
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"demand" 1.0 0 -14439633 true "ask turtles[plot demand]" "ask turtles[plot demand]"

PLOT
1305
95
1527
245
Quantity of Goods
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Supply" 1.0 0 -14454117 true "ask turtles[plot supply]" "ask turtles[plot supply]"

SLIDER
288
675
474
708
fed_interest_rates
fed_interest_rates
0
15
6.7
0.1
1
NIL
HORIZONTAL

SLIDER
9
232
195
265
capital_gains_tax_rates
capital_gains_tax_rates
0
25
17
0.5
1
NIL
HORIZONTAL

SLIDER
77
485
273
518
lb_income_tax_rates
lb_income_tax_rates
0
100
50
1
1
NIL
HORIZONTAL

SLIDER
312
488
519
521
mb_income_tax_rates
mb_income_tax_rates
0
100
80
1
1
NIL
HORIZONTAL

SLIDER
556
488
758
521
hb_income_tax_rates
hb_income_tax_rates
0
100
78
1
1
NIL
HORIZONTAL

TEXTBOX
341
522
491
582
lb = lower bracket\nmb = middle bracket\nhb = high bracket\n
16
0.0
1

SLIDER
80
587
275
620
lb_threshold
lb_threshold
0
100
13
1
1
NIL
HORIZONTAL

SLIDER
306
587
513
620
mb_threshold
mb_threshold
0
100
21
1
1
NIL
HORIZONTAL

SLIDER
556
587
760
620
hb_threshold
hb_threshold
0
100
15
1
1
NIL
HORIZONTAL

TEXTBOX
1288
866
1438
905
GDP = private consumption + gross investment + government spending + (exports − imports)
10
0.0
1

SLIDER
8
370
201
403
entitlement_spending
entitlement_spending
0
100000
62360
1
1
NIL
HORIZONTAL

TEXTBOX
1168
528
1318
548
NIL
16
0.0
1

PLOT
795
705
1029
855
Income Inequality
Aggregate Pop.
Aggregate Wealth
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range  min-pycor max-pycor" ""
PENS
"Pop." 1.0 0 -5298144 true "ask persons[plot count turtles]" "ask persons[plot count turtles]"
"Wealth" 1.0 0 -14985354 true "ask turtles[plot aggregate_capital]" "ask turtles[plot aggregate_capital]"

TEXTBOX
1289
913
1439
955
Since the simulation is a closed system, (exports - imports) = 0.
11
0.0
1

TEXTBOX
38
410
188
438
Money the Government spends on social services
11
0.0
1

SLIDER
659
142
824
175
set_stimulus
set_stimulus
0
100000
100000
1
1
NIL
HORIZONTAL

SLIDER
12
539
198
572
mininum_wage
mininum_wage
0
100
3
1
1
NIL
HORIZONTAL

PLOT
792
524
1029
674
Market Equilibrium
Tending Quantity
Tending Price
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range  min-pycor max-pycor" ""
PENS
"Q" 1.0 0 -5298144 true "ask turtles[plot equilibrium_quantity]" "ask turtles[plot equilibrium_quantity]"
"P" 1.0 0 -14454117 true "ask turtles[plot equilibrium_price]" "ask turtles[plot equilibrium_price]"

TEXTBOX
245
636
465
676
= = FED/Monetary Policy = =
16
0.0
1

SLIDER
12
674
256
707
required_reserve_ratio
required_reserve_ratio
0
100
26
1
1
NIL
HORIZONTAL

SLIDER
654
328
823
361
%_gov_cuts
%_gov_cuts
0
100
40
1
1
NIL
HORIZONTAL

PLOT
1226
522
1452
672
AD-AS Model
GDP
Price
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range  min-pycor max-pycor" ""
PENS
"AD" 1.0 0 -5298144 true "ask turtles[plot (C + G + I)]" "ask turtles[plot (C + G + I)]"
"AS" 1.0 0 -14070903 true "ask turtles[plotxy (C + G + I) aggregate_supply ]" "ask turtles[plotxy (C + G + I) aggregate_supply  ]"

TEXTBOX
1084
344
1228
476
The Phillips Curve is the short term phenomenom between the way inflation and unemploymet relate to each other after a massive influx in capital. Add a stimulus or 2 to see it in action!
12
0.0
1

TEXTBOX
34
11
184
180
WELCOME:\nKey terms:\nCapital: Money\nCapital gains: Money earned through investments\nCorporations: Businesses\nEntitlement: Social services\nMininum Wage: Lowest salary allowed\nThreshold: Mininum amount a tax rate applies to\nLook around and explore the other notes! 
10
0.0
1

TEXTBOX
513
670
759
778
The FED, or Federal Reserve, controls monetary policy. I.e. it dictates how much a bank can borrow and how much money must be in a bank.
12
0.0
1

TEXTBOX
46
712
196
832
The reserve requirement is the mininum number of deposits or invetsments that a bank must have. 
12
0.0
1

TEXTBOX
664
186
822
271
Adds more money into the economy, inreases the value of each prices all around since people have more money to spend(inflation)
12
0.0
1

TEXTBOX
666
370
816
461
Decreases entitlement spending(and is done in conjugation with tax rate increases) It could also lead to a drop in capital and thus slower inflation.
12
0.0
1

TEXTBOX
882
119
1032
181
Backs each dollar introduced with gold, lowering inflation rates dramatically.
12
0.0
1

TEXTBOX
882
241
1040
349
Lowest 10% of people, in terms of income, gain money instead of paying a tax and the next 10% simply pay no tax
12
0.0
1

TEXTBOX
847
61
862
281
-\n-\n-\n-\n-\n-\n-\n-\n-\n-\n-\n
16
0.0
1

TEXTBOX
1255
17
1552
93
The Laws of Sppply and Demand have corporations compete with each to lower or highten their prices/quantity in order to  maximize their profit and work for the maximization of the consumer's savings
12
0.0
1

TEXTBOX
1043
514
1193
679
A graph displaying to the user the changing equilibrium prices/quantities desired by the consumers aand companies. Notice how under massive inflation or stimulus both rise due to increasing capital and, as a result, an increase in demand. 
12
0.0
1

TEXTBOX
1044
702
1194
1042
A graph displaying the difference between the wealth accumulated by everybody versus the size of the population. The more spread out, or higher, the tax rates the lower the wealth line and thus a higher inequality. With inflation there is a bump in wealth due to more capital and more demand for goods.
12
0.0
1

TEXTBOX
1505
340
1655
490
How much revenue the government is bringing in, based on how high or low the tax rates are. Higher tax rates may increase GDP and highten income inequaliity, along with slowing down price increase due to less capital and thus slower inflation. 
12
0.0
1

TEXTBOX
1464
496
1620
706
A graph relating the demand felt throughout the whole economy to the total supply of goods available. In general, over the long-term, any increase in capital would slowly increase the aggregate demand(AD) while sharply increasing the aggregate supply(AS). So much so that AS will appear as a vertical line to the user.
12
0.0
1

TEXTBOX
1464
701
1631
926
A graph relating FED_interest_rates with GDP growth. GDP, a calculation of all products and services avaiable in an economy, generally rises with increases in capital and inflation. It will also fall if government spending decreases, as that is taken into account as well. In general FED_interest_rates should be changed to help GDP perform an upward trend.
12
0.0
1

MONITOR
230
728
456
793
Money Multiplier
1 / required_reserve_ratio
17
1
16

TEXTBOX
467
736
617
811
The money multiplier is just (1 / required_reserve ratio). It tells you the maximum amount of loans a bank can give
12
0.0
1

TEXTBOX
44
790
194
902
NOTE: Banks are not visually present in the simulation since the main focus of the simulation is on the prices the corporations set and where people go based on their pay and how the corporation is doing.
11
0.0
1

TEXTBOX
515
529
665
577
threshold = If you earn this much or more, you get taxed by x%
13
0.0
1

TEXTBOX
1658
576
1873
689
GDP = Compensation of employees + Rents + Interest + Proprietors’ income +\nCorporate profits (Corporate income taxes + dividends + undistributed corporate\nprofits) + indirect business taxes + depreciation (consumption of fixed capital) + net\nforeign factor income
11
0.0
1

PLOT
1641
753
1841
903
Production Possibilities Curve
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

MONITOR
1656
512
1822
565
GDP(Income Approach)
GDP_income_approach
17
1
13

MONITOR
1708
693
1765
746
PI
Personal_Income
17
1
13

MONITOR
1640
693
1697
746
NI
National_Income
17
1
13

MONITOR
1781
695
1838
748
DI
Domestic_Income
17
1
13

MONITOR
230
793
287
846
NIL
M1
17
1
13

MONITOR
315
793
372
846
NIL
M2
17
1
13

MONITOR
399
793
456
846
NIL
M3
17
1
13

@#$#@#$#@
## About

A simulation of a rudimentary network of markets. Consumers and Producers are simulated along with the affects of certain few governmental regulations on those agents.


Using the law of supply and demand along with various other recorded economic phenomena, closed market output is simulated.



The user simply plays around with the income tax rate and corporate tax rate sliders, and the buttons under certain brances of macroeconomic theory which dictate certain patterns to follow when some action is taken by the buttons. The user will learn various phenomena proposed by those schools of thought by playing around with the rules in a simulated market and seeing what happens to the market's well-being. 

NOTE: Banks are not in the simulation since the main focus of the simulation is on the prices the corporations set and where people go based on their pay and how the corporation is doing.

## Instructions
The various amount of buttons/sliders control various aspects of the simulation. 

Tax Rates:
 On the bottom and the side are various sliders for different brackets of income or corporate/capital gains tax rates. Income brakcets are determined by the thresholds the users set with the sliders below. I.e. the mininum income needed for the tax to apply. This various tax rates can then influence the laffer curve, i.e. how much revenue is received.
 FED:
 Under the FED section the user can control at what rate banks can borrow money from   the FED and how many deposits the banks must have. 

Remember economics is all about optimal allocation of scarce resources. The means of producing some good or service are limited.

##WhatShouldIBeSeeing?
REMEMBER: The red denotes the x-axis and the yellow the y-axis
Interesting phenomena to observe:
- Laws of Supply and Demand
    Markets will always tend towards the price and supply where every seller sells and      every buyer buys, making everyone happy. 
- Balanced Budget Multiplier; 
    Doubling both government spending and tax rates doubles GDP as well
- Stagflation;
    Too much inflation will always cause unemployment to stay steady as more inflation       is introduced
- Multiplier Effect:
    Changes in aggregate expenditures can increase GDP since the money entering the          market is used over many times
- Monetarist Equation of Exchange
    MV = PQ where V is a constant for the average amount of times a year money is           spent, M is supply of money and where P is the price and Q is quantity. So 2 apples     for $5 represents only $10 in the supply of money that is being exchanged. While        there will be times where investments are kept in cold hands than at the bank, it       generally holds true in this simulation. 
- Phillips Curve:
    This is a very interesting phenomena where if a lot of money is put into the market     inflation rates at first go crazy and unemployment goes down, but then it               stagflates by itself over time. 
- AD/AS longrun:
    When there is a sudden increase in capital, either through tax decreases or             stimulus packages, aggregate demand slowly rises up while in the long run supply        looks like a vertical line when graphed. What happens in the shortrun is still          debated between economists today, with some economists saying that there is a           slow rise with AS and others saying that it stays horizontal.
- Frictional Unemployment 
    Unemployment that happens because one job is too far from where a person lives,         you'll notice this quite a bit in the simulation.

## Credits

Norman Period 6

Special Thanks to Mr. Brooks
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bank
true
0
Rectangle -13840069 true false 90 135 210 195
Rectangle -6459832 true false 120 90 180 135
Rectangle -955883 true false 135 165 165 195
Rectangle -2674135 true false 135 150 165 165

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

corporation
true
0
Rectangle -2674135 true false 60 135 240 180
Rectangle -6459832 true false 90 90 210 135
Rectangle -1184463 true false 120 60 180 90
Line -2674135 false 150 60 150 30
Rectangle -13345367 true false 150 30 165 45
Rectangle -16777216 true false 135 150 165 180

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
