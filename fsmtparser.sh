clear
echo ""
for file in *R1*
do

	# Find reads
	while read bcode
	do

	x=`expr $(($x + 1))`
		# Find forward reads for PLATEX in Read1
		echo "Searching for forward PLATE$x reads in $file.."
		grep $bcode -B 1 -A 2 -h  $file >> $file.PLATE$x.Read1temp.fastq;
			sed '/^--$/d' $file.PLATE$x.Read1temp.fastq >> $file.PLATE$x.Read1.fastq;
			rm *Read1temp*	

		# Generate list reads by searching for all UNC or HWI
		# NOTE: may need to be changed depending on sequencer prefix.

		grep -e "^@UNC" -e "^@HWI" -h  $file.PLATE$x.Read1.fastq >> $file.SEQIDS;
		sed -r 's/.{14}$//' $file.SEQIDS >> $file.Read2IDS.fastq;
		rm *SEQIDS;

		# Search for matching reverse reads
		echo $file > tempfile.txt;
		sed -i 's/R1/R2/g' tempfile.txt >> tempfile.txt;
		var=$(head -n 1 tempfile.txt)
		echo "Searching for reverse PLATE$x reads in $var.."

			while read ids;
			do
				grep $ids -m 1 -A 3 -h  $var >> $file.PLATE$x.Read2.fastq
			done < $file.Read2IDS.fastq

		# Clean up temporary files and deposit PLATEX reads
		rm *IDS.fastq;
		rm tempfile.txt;
		mkdir -p PLATE$x
		mv *PLATE$x.Rea* PLATE$x

	echo ""
	done < barcodes.txt
	x=0

clear
done
echo ""
echo "Script complete!"
echo ""
