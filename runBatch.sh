OPTIND=1

outdir="output"
indir="input/styles/*"
sweight=1000
cweight=100
seed=123
size=512
iter=1000

while getopts "h?:c:s:o:d:t:i:z:" opt; do
	case "${opt}" in
	c ) cweight=$OPTARG
	;;
	s ) sweight=$OPTARG
	;;
	o ) outdir=$OPTARG
	;;
	d ) seed=$OPTARG
	;;
	t ) iter=$OPTARG
	;;
	i ) indir=$OPTARG
	;;
	z ) size=$OPTARG
	;;
	h|\?)
	echo "sh runNINnet.sh -[cstiozh] <content-image>
		-c	content weight
		-s	style weight
		-t	number of iterations
		-i 	style files
		-o	output directory
		-z	output size
		-h	display help"
		exit 0
	;;
	esac
done

shift $(($OPTIND - 1))

for file in $indir
do 
filename=$(basename "$file")
ofile="$outdir/${filename%.*}_output.png"

th neural_style.lua -gpu 0 -backend clnn -save_iter 0 -image_size $size -num_iterations $iter -seed $seed -style_weight $sweight -content_weight $cweight -output_image $ofile -style_image $file -content_image $1
done
