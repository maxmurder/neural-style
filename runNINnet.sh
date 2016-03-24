OPTIND=1

outfile="output/output.png"

sweight=1000
cweight=100
seed=123
size=512
iter=1000

while getopts "h?:c:s:o:d:i:z:" opt; do
	case "${opt}" in
	c ) cweight=$OPTARG
	;;
	s ) sweight=$OPTARG
	;;
	o ) outfile=$OPTARG
	;;
	d ) seed=$OPTARG
	;;
	i ) iter=$OPTARG
	;;
	z ) size=$OPTARG
	;;
	h|\?)
	echo "sh runNINnet.sh -[csiozh] <content-image> <style-image>
		-c	content weight
		-s	style weight
		-i	number of iterations
		-o	output file
		-z	output size
		-h	display help"
		exit 0
	;;
	esac
done

shift $(($OPTIND - 1))

th neural_style.lua -gpu 0 -backend clnn -optimizer adam -model_file models/nin_imagenet_conv.caffemodel -proto_file models/train_val.prototxt -content_layers relu0,relu3,relu7,relu12 -style_layers relu0,relu3,relu7,relu12 -normalize_gradients -image_size $size -num_iterations $iter -seed $seed -output_image $outfile -style_weight $sweight -content_weight $cweight -content_image $1 -style_image $2
