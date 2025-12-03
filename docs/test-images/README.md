# Test Images for GPS Check Workflow

This directory contains test images for validating the `.github/workflows/image-check.yml` workflow.

## Test Cases

### 1. Image with GPS data (should fail check)

**File:** `test-with-gps.jpg`

This image contains GPS coordinates (San Francisco: 37.7749°N, 122.4194°W). The workflow should detect this GPS data and fail the check.

To verify GPS data:

```bash
exiftool -gps:all test-images/test-with-gps.jpg
```

### 2. Image without GPS data (should pass)

**File:** `test-no-gps.jpg`

This is a clean image with no GPS metadata. The workflow should pass for this image.

To verify no GPS data:

```bash
exiftool -gps:all test-images/test-no-gps.jpg
```

### 3. Filename with spaces (edge case)

**File:** `test image with spaces.jpg`

This image has spaces in its filename to test proper handling of filenames with whitespace. The workflow should process this without errors.

## Running Tests Locally

To test the GPS check logic locally:

```bash
# Test the image with GPS (should detect GPS)
exiftool -gps:all test-images/test-with-gps.jpg | grep "GPS"

# Test the clean image (should return nothing)
exiftool -gps:all test-images/test-no-gps.jpg | grep "GPS" || echo "No GPS data"

# Test spaces in filename
exiftool -gps:all "test-images/test image with spaces.jpg"
```

## Removing GPS Data

If you need to strip GPS data from an image, use the just command:

```bash
just gps_rm test-images/test-with-gps.jpg
```

## Creating Your Own Test Images

To create a test image with GPS data:

```bash
# Create a simple image
magick -size 100x100 xc:blue test.jpg

# Add GPS coordinates
exiftool -GPSLatitude="37.7749" -GPSLatitudeRef="N" \
         -GPSLongitude="122.4194" -GPSLongitudeRef="W" \
         -overwrite_original test.jpg
```
