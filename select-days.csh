#!/bin/csh
set ND = `pwd`
set com = HDH
set com1 = HH
set lag1 = -200
set lag2 = 200
set threshold = 0.1

#goto www
if ( ! -d $ND/lst ) mkdir $ND/lst
#################################
#foreach ST ( L1101-L1102 L1101-L1104 L1101-L1105 L1101-L1106 L1101-Y1102 L1101-Y1103 L1101-Y1105 L1102-L1104 L1102-L1105 L1102-L1106 L1102-Y1102 L1102-Y1103 L1102-Y1105 L1104-L1105 L1104-L1106 L1104-Y1102 L1104-Y1103 L1104-Y1105 L1105-L1106 L1105-Y1102 L1105-Y1103 L1105-Y1105 L1106-Y1102 L1106-Y1103 L1106-Y1105 Y1102-Y1103 Y1102-Y1105 Y1103-Y1105 Y1507-Y1508 Y1507-Y1509 Y1508-Y1509 Y1601-Y1602 Y1601-Y1603 Y1601-Y1604 Y1601-Y1605 Y1601-Y1606 Y1602-Y1603 Y1602-Y1604 Y1602-Y1605 Y1602-Y1606 Y1603-Y1604 Y1603-Y1605 Y1603-Y1606 Y1604-Y1605 Y1604-Y1606 Y1605-Y1606 )
foreach ST ( Y1507-Y1508 Y1507-Y1509 Y1508-Y1509 Y1601-Y1602 Y1601-Y1603 Y1601-Y1604 Y1601-Y1605 Y1601-Y1606 Y1602-Y1603 Y1602-Y1604 Y1602-Y1605 Y1602-Y1606 Y1603-Y1604 Y1603-Y1605 Y1603-Y1606 Y1604-Y1605 Y1604-Y1606 Y1605-Y1606 )
#foreach ST ( YB01-YB02 YB01-YB03 YB01-YB04 YB01-YB05 YB02-YB03 YB02-YB04 YB02-YB05 YB03-YB04 YB03-YB05 YB04-YB05 L1101-L1102 L1101-L1104 L1101-L1105 L1101-L1106 L1101-Y1102 L1101-Y1103 L1101-Y1105 L1102-L1104 L1102-L1105 L1102-L1106 L1102-Y1102 L1102-Y1103 L1102-Y1105 L1104-L1105 L1104-L1106 L1104-Y1102 L1104-Y1103 L1104-Y1105 L1105-L1106 L1105-Y1102 L1105-Y1103 L1105-Y1105 L1106-Y1102 L1106-Y1103 L1106-Y1105 Y1102-Y1103 Y1102-Y1105 Y1103-Y1105 Y1507-Y1508 Y1507-Y1509 Y1508-Y1509 Y1601-Y1602 Y1601-Y1603 Y1601-Y1604 Y1601-Y1605 Y1601-Y1606 Y1602-Y1603 Y1602-Y1604 Y1602-Y1605 Y1602-Y1606 Y1603-Y1604 Y1603-Y1605 Y1603-Y1606 Y1604-Y1605 Y1604-Y1606 Y1605-Y1606 )
foreach filterid ( 01 02 03 )
set sta1 = `echo $ST | awk -F- '{print $1}'`
set sta2 = `echo $ST | awk -F- '{print $2}'`
set STbug = ${sta1}_${sta2}
set used = $ND/lst/$ST.$com.$filterid.used_cc.lst
if ( -f $used ) rm -rf $used

set day_dir = $ND/STACKS/$filterid/001_DAYS/$com1/$STbug
set allday_dir = $ND/allday/$com-$ST/$filterid
if ( ! -d $allday_dir ) mkdir -p $allday_dir
set n = `\ls $allday_dir/ | wc -l`
if ( $n == 0 ) mv $day_dir/* $allday_dir/

rm -f $day_dir/*

set stack_dir = $ND/STACKS/$filterid/REF/$com1
set allstack_dir = $ND/allstack/$com-$ST/$filterid
if ( ! -d $allstack_dir ) mkdir -p $allstack_dir
set n = `\ls $allstack_dir/ | wc -l`
if ( $n == 0 ) mv $stack_dir/$ST.*.SAC $allstack_dir/

set allstack = $allstack_dir/${ST}.*.SAC  # all day stacked ccf
#\ls $allstack
if ( ! -f $allstack ) then
echo $allstack
exit
endif

set cor = $ND/lst/$ST.$com.$filterid.correlation_cc.lst
if ( -f $cor ) rm -rf $cor

cd $allday_dir
foreach dailycc ( `\ls *.SAC` )  # daily ccfs
#set mdate = `echo $dailycc | awk -F. '{print $3}'` # julian day

~/bin/sac_correlation << EOF >! /dev/null
$dailycc
$allstack
$lag1 $lag2
EOF

#echo $dailycc
if ( ! -f cor.out ) exit
set mat = `cat cor.out | awk -F= '/corval/{print $2}' | awk -v a=$threshold '($1>=a){print $0}' | wc -l`
set cc = `cat cor.out | awk -F= '/corval/{print $2}'`
echo $dailycc $cc >> $cor
rm -rf cor.out
if ( $mat == 0 ) goto cskip
echo "$com $cc $dailycc " >>! $used
cp $dailycc $day_dir/
cskip:
end ## dailycc
if ( ! -f $used ) then # no daily cc with correlation >= 0.5
echo "$ST-$com has no daily cc with correlation >= $threshold "
goto NE
endif
set nxcc = `cat $used | awk '{print $3}' | wc -l `
if ( $nxcc == 0 ) then
rm -rf $used
goto NE
endif
echo "$com cor>=threshold $nxcc"

NE:
# rstack by selected ccfs
cd $ND
end # filterid
end ## ST
msnoise stack -r

#www:
#foreach ST ( L1101-L1102 L1101-L1104 L1101-L1105 L1101-L1106 L1101-Y1102 L1101-Y1103 L1101-Y1105 L1102-L1104 L1102-L1105 L1102-L1106 L1102-Y1102 L1102-Y1103 L1102-Y1105 L1104-L1105 L1104-L1106 L1104-Y1102 L1104-Y1103 L1104-Y1105 L1105-L1106 L1105-Y1102 L1105-Y1103 L1105-Y1105 L1106-Y1102 L1106-Y1103 L1106-Y1105 Y1102-Y1103 Y1102-Y1105 Y1103-Y1105 Y1507-Y1508 Y1507-Y1509 Y1508-Y1509 Y1601-Y1602 Y1601-Y1603 Y1601-Y1604 Y1601-Y1605 Y1601-Y1606 Y1602-Y1603 Y1602-Y1604 Y1602-Y1605 Y1602-Y1606 Y1603-Y1604 Y1603-Y1605 Y1603-Y1606 Y1604-Y1605 Y1604-Y1606 Y1605-Y1606 )
foreach ST ( Y1507-Y1508 Y1507-Y1509 Y1508-Y1509 Y1601-Y1602 Y1601-Y1603 Y1601-Y1604 Y1601-Y1605 Y1601-Y1606 Y1602-Y1603 Y1602-Y1604 Y1602-Y1605 Y1602-Y1606 Y1603-Y1604 Y1603-Y1605 Y1603-Y1606 Y1604-Y1605 Y1604-Y1606 Y1605-Y1606 )
#foreach ST ( YB01-YB02 YB01-YB03 YB01-YB04 YB01-YB05 YB02-YB03 YB02-YB04 YB02-YB05 YB03-YB04 YB03-YB05 YB04-YB05 L1101-L1102 L1101-L1104 L1101-L1105 L1101-L1106 L1101-Y1102 L1101-Y1103 L1101-Y1105 L1102-L1104 L1102-L1105 L1102-L1106 L1102-Y1102 L1102-Y1103 L1102-Y1105 L1104-L1105 L1104-L1106 L1104-Y1102 L1104-Y1103 L1104-Y1105 L1105-L1106 L1105-Y1102 L1105-Y1103 L1105-Y1105 L1106-Y1102 L1106-Y1103 L1106-Y1105 Y1102-Y1103 Y1102-Y1105 Y1103-Y1105 Y1507-Y1508 Y1507-Y1509 Y1508-Y1509 Y1601-Y1602 Y1601-Y1603 Y1601-Y1604 Y1601-Y1605 Y1601-Y1606 Y1602-Y1603 Y1602-Y1604 Y1602-Y1605 Y1602-Y1606 Y1603-Y1604 Y1603-Y1605 Y1603-Y1606 Y1604-Y1605 Y1604-Y1606 Y1605-Y1606 )
foreach filterid ( 01 02 03 )
cd $ND
# move time -200
set stack_dir = $ND/STACKS/$filterid/REF/$com1
cd $stack_dir
set file = `\ls $ST*.SAC`
xshift << EOF
$file
$file
-200
EOF

# cut pos, neg, symm
~/wangw2/NOISE/bin/1p_cut2parts << EOF
$file
EOF
\mv cut.sac $file.pos
\mv ncut.sac $file.neg
\mv symm.sac $file.symm

# write header
set list = /Users/home/wangw2/wangw2/data-tw/pairlist-NE
set dist = `cat $list | awk '($1==o){print $3}' o=$ST`
set az = `cat $list | awk '($1==o){print $5}' o=$ST`
set baz = `cat $list | awk '($1==o){print $4}' o=$ST`
sac << EOF
r $file $file.pos $file.symm
ch kcmpnm $com kstnm $ST dist $dist az $az baz $baz
wh
r $file.neg
ch kcmpnm $com kstnm $ST dist $dist baz $az az $baz
wh
q
EOF

end # filterid
end ## ST
