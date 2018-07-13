# face_rec
A collection of script supporting face recognition.

These scripts prepare input files and analyze outcome of the actual [face_recognition](https://github.com/ageitgey/face_recognition) processor. The image data comes from a custom source and is not uploaded to this repo.

Training and test images are expected to reside in `face_train` directory and have the following naming scheme:

```
6005-1.jpg
6005-2.jpg
6005-3.jpg
6005-t.jpg
```

where `6005` is the label (alternatively could be a person name), `-` is a separator, and `1, 2, and 3` are indexes of the different images of the same person, and `t` is a test image which is never used in training.

## Prerequisites

1. Working installation of [face_recognition](https://github.com/ageitgey/face_recognition) api.
2. Ruby ~> 2.3

## Installation

Clone and run `bundle install`.

## How to use

1. Make sure `face_train`, `fr_known` and `fr_unknown` directories exist under the `project root`
2. Run `ruby ./lib/face_rec/prepare.rb`. It will copy a single training and the test image to the working locations. It will ask some questions with the defaults shown between `|pipes|`
```
Source images directory: |./face_train|
Training set image index: |0|
Known images directory: |./fr_known|
Unknown images directory: |./fr_unknown|
```

Note that `Training set image index` is a zero-based index of an image in the array of person's images, not the actual suffix value present in the original file name (`1,2,3` in the example above).

After this you should have the respective images copied to `./fr_known` and `./fr_unknown`.

3. Run `face_recognition --cpus -1 --show-distance true ./fr_known ./fr_unknown > ./output/fr_results_0.csv`
4. Run `ruby ./lib/face_rec/analyze.rb`. It will ask for the `face_recognition` output
```
Face recognition output csv: |./output/fr_results_0.csv|
```

Observe the results.
