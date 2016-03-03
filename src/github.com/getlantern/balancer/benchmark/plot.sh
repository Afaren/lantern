#!/usr/bin/env sh

declare -a names=("DialTime" "Throughput")
declare -a sizes=("small" "medium" "large")

mkdir -p png
for name in "${names[@]}"; do
  for size in "${sizes[@]}"; do
    cp gnuplot.script  gnuplot.script.$name.$size
  done
done
for size in "${sizes[@]}"; do
  line1="plot "
  line2="plot "
  for file in *443.csv; do
    grep $size $file > $file.$size
    series=`echo $file | cut -d "_" -f 2 | cut -d ":" -f 1`

    part1=" '$file' using 2:4 title '$series' with lines,"
    line1+=$part1
    cp gnuplot.script  gnuplot.script.$series."${names[0]}".$size
    echo "set title '$series ${names[0]} $size'" >> gnuplot.script.$series."${names[0]}".$size
    echo "set ylabel 'ms'" >> gnuplot.script.$series."${names[0]}".$size
    echo "plot $part1" >> gnuplot.script.$series."${names[0]}".$size
    gnuplot gnuplot.script.$series."${names[0]}".$size > png/$series."${names[0]}".$size.png

    part2=" '$file' using 2:9 title '$series' with lines,"
    line2+=$part2
    cp gnuplot.script  gnuplot.script.$series."${names[1]}".$size
    echo "set title '$series ${names[1]} $size'" >> gnuplot.script.$series."${names[1]}".$size
    echo "set ylabel 'Bps'" >> gnuplot.script.$series."${names[1]}".$size
    echo "plot $part2" >> gnuplot.script.$series."${names[1]}".$size
    gnuplot gnuplot.script.$series."${names[1]}".$size > png/$series."${names[1]}".$size.png

  done

  echo "set title '${names[0]} $size'" >> gnuplot.script."${names[0]}".$size
  echo "set ylabel 'ms'" >> gnuplot.script."${names[0]}".$size
  echo "$line1" >> gnuplot.script."${names[0]}".$size

  echo "set title '${names[1]} $size'" >> gnuplot.script."${names[1]}".$size
  echo "set ylabel 'Bps'" >> gnuplot.script."${names[1]}".$size
  echo "$line2" >> gnuplot.script."${names[1]}".$size
done

for name in "${names[@]}"; do
  for size in "${sizes[@]}"; do
    gnuplot gnuplot.script.$name.$size > png/$name.$size.png
  done
done

for size in "${sizes[@]}"; do
  rm *.$size
done
