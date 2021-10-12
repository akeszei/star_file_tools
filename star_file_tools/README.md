# star_file_tools
Scripts focused on manipulating `.star` files generated by `relion` ver. 3.1 (https://github.com/3dem/relion) for various uses, from generating rapid figures to remapping particle coordinates to other formats. Note, this repo is a work-in-progress as numerous scripts need to be upgraded to handle changes to `.star` file outputs from `relion` ver. 3 to 3.1. 

## Usages

#### select_into_manpick.py
Remap particles from any `.star` file containing particle coordinates (`_rlnCoordinateX` and `_rlnCoordinateY`) into individual `_manpick.star` files that can be copied into a new `ManualPick` job for visualization or rebooting a processing pipeline using a curated particle set. Typically, this script is run in a subfolder from a `Select` job, e.g.

`select_into_manpick.py   ../particles.star `

The script will generate a set of `_manualpick.star` files corresponding to each micrograph present in the `.star` file.

-----
#### class3D_statistics.py
Run this script within a `Class3D` directory to parse the class distribution and estimated resolution for each class at each iteration to assess if all classes have converged (i.e. if the user should continue the classification run for more iterations).  


-----
#### remap_optics_groups.py
Modify a `.star` file with particle data to edit the `_rlnOpticsGroup` column value to a user-defined value.  

`remap_optics_groups.py  particles.star  mic_name_match_critera  optics_group_value  `

Typical use-case for this script is to update the particle metadata after manually updating the optics table to separate micrographs by their beam tilt group, assuming the micrograph name can be sorted using a glob pattern, e.g.:

`remap_optics_groups.py  particles.star  Micrograph*012.mrc  12  `

-----
#### display_class2D.py
Run this script in a `Class2D` job, pointing to the final iteration `_model.star` and `templates.mrcs` file to generate an image of arrayed 2D classes sorted by either class distribution or estimated resolution. 

`display_class2D.py  classes.mrcs  model.star  `

Optionally can include a scalebar of defined size (in Angstroms) with custom position, stroke, and other options.

-----
#### remove_mics_from_star.py
The goal of this script is to take an input micrographs.star file and a list of micrographs (basenames only) and return a new .STAR file where micrographs have been removed. Typically, this script should be run on a ManualPick job 'micrographs_selected.star' file to unselect bad micrographs from the dataset after manual curation.

`remove_mics_from_star.py  image_list.txt  micrographs_selected.star  `

In the above example, the command will write out a new file of the name: `micrographs_selected_micsRemoved.star`.

Optionally, can target a different data table in the `.star` file using the `--table` flag, or change the output name of the file to a specific one via the `--out` flag, e.g.:

`remove_mics_from_star.py  image_list.txt  run_it020_data.star  --table data_particles --out edited_data_file.star`

---

## Dependencies
The goal of these scripts are to provide straight-forward, flexible, scripts that have simple cross-platform dependencies. Many use built-in python modules, others can be installed via `pip` or are provided within the repo itself. 

#### NumPy
Calculation & array handling in python. See: (https://numpy.org/)

`pip install numpy`

#### Pillow (PIL fork)  
Handles image formats for .JPG, .PNG, .TIF, .GIF. See: (https://pillow.readthedocs.io/en/stable/)  

`pip install --upgrade Pillow`

#### mrcfile   
I/O parser for .MRC image format. See: (https://pypi.org/project/mrcfile/)/

`pip install mrcfile`