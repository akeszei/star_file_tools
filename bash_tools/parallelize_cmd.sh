## Assign number of working threads
N=12

## Create the task for each individual unit of work 
task(){
   input_mrcs=$1
   bg_radius=84
   out_folder='normalized/'
   create_dir $out_folder
   ## test run command using echo first, then re-run without echo command
   echo relion_preprocess --operate_on $input_mrcs --operate_out ${out_folder}${input_mrcs} --norm --float16 --bg_radius $bg_radius
}

create_dir(){
   if [ -d $1 ]; then
      echo " Output directory ($1) already exists! Check & delete it before re-running"
      exit 1
   else 
      echo " Creating output directory for processed files: $1"
      mkdir $1 
   fi

}

## Prepare the list of working elements via globbing and pass them through a iterator with background execution in batches 
(
   for job in *.mrcs ; do 
      
      ## create batches on-the-fly using a variable initialized at 0 and execute them in the background, adding the wait command on the first operation, thus restricting the run until all its children threads are done 
      ((i=i%N)); ((i++==0)) && wait 

      ## launch a job for the input file in the background 
      task "$job" & 

   done
)

echo " COMPLETE"
echo " ... rename the processed directory to match the particles.star file entries, then use in RELION" 