# Procedure

Newer versions of llama.cpp are constantly relased. We will check out a specific version (b5050 from April 2025) known to be working to ensure this repository keeps working in the future. If you want to try a more recent version remove the steps `git checkout 23106f9` and `git checkout -b llamaJetsonNanoCUDA` in the following instructions:

## 1. Clone repository

``` sh
git clone https://github.com/ggml-org/llama.cpp llama5050gpu.cpp
cd llama5050gpu.cpp
git checkout 23106f9
git checkout -b llamaJetsonNanoCUDA
```

For the next steps 2. to 5. we have to make changes to these 6 files:

- CMakeLists.txt 14
- ggml/CMakeLists.txt 274
- ggml/src/ggml-cuda/common.cuh 455
- ggml/src/ggml-cuda/fattn-common.cuh 623
- ggml/src/ggml-cuda/fattn-vec-f32.cuh 71
- ggml/src/ggml-cuda/fattn-vec-f16.cuh 73

In early 2025 llama.cpp started supporting and using `bfloat16`, a feature not included in nvcc 10.2. We have two options:

- Option A: Create two new files
    - /usr/local/cuda/include/cuda_bf16.h
    - /usr/local/cuda/include/cuda_bf16.hpp
- Option B: Edit 3 files
    - ggml/src/ggml-cuda/vendors/cuda.h
    - ggml/src/ggml-cuda/convert.cu
    - ggml/src/ggml-cuda/mmv.cu

Details for each option are described below in step 2 to 7:

## 2. Add a limit to the CUDA architecture in `CMakeLists.txt`

Edit the file *CMakeLists.txt* with `nano CMakeLists.txt`. Add the following 3 lines after line 14 (with **Ctrl+\_** you can jump to this line, check line with **Ctrl+c**):

```
if(NOT DEFINED ${CMAKE_CUDA_ARCHITECTURES})
    set(CMAKE_CUDA_ARCHITECTURES 50 61)
endif()
```

Save with **Ctrl+o** and exit with **Ctrl+x**.

## 3. Add two linker instructions after line 274 in `ggml/CMakeLists.txt`

Edit the file with `nano ggml/CMakeLists.txt` and enter two new lines after `set_target_properties(ggml PROPERTIES PUBLIC_HEADER "${GGML_PUBLIC_HEADERS}")` and before `#if (GGML_METAL)`. It should then look like:

``` h
set_target_properties(ggml PROPERTIES PUBLIC_HEADER "${GGML_PUBLIC_HEADERS}")
target_link_libraries(ggml PRIVATE stdc++fs)
add_link_options(-Wl,--copy-dt-needed-entries)
#if (GGML_METAL)
#    set_target_properties(ggml PROPERTIES RESOURCE "${CMAKE_CURRENT_SOURCE_DIR}/src/ggml-metal.metal")
#endif()
```

With `target_link_libraries(ggml PRIVATE stdc++fs)` and `add_link_options(-Wl,--copy-dt-needed-entries)` we avoid some static link issues that don't appear in later gcc versions. See [nocoffei's comment](https://nocoffei.com/?p=352).

## 4. Remove *constexpr* from line 455 in `ggml/src/ggml-cuda/common.cuh`

Use `nano ggml/src/ggml-cuda/common.cuh` to remove the **constexpr** after the *static* in line 455. This feature from CUDA C++ 17 we don't support anyway. After that it looks like:

``` h
// TODO: move to ggml-common.h
static __device__ int8_t kvalues_iq4nl[16] = {-127, -104, -83, -65, -49, -35, -22, -10, 1, 13, 25, 38, 53, 69, 89, 113};
```

## 5. Comment lines containing *__buildin_assume* by adding "//" in 3 files

Comment the lines by adding a // in front of these 3 files. This avoids the compiler error *"__builtin_assume" is undefined*.

- line 623, `nano ggml/src/ggml-cuda/fattn-common.cuh`
- line 71, `nano ggml/src/ggml-cuda/fattn-vec-f32.cuh`
- line 73, `nano ggml/src/ggml-cuda/fattn-vec-f16.cuh`

If you have a version lower than b4400 you can skip the next step.

In January 2025 with version larger than b4400 llama.cpp started including support for `bfloat16`. There is a standard library `cuda_bf16.h` in the folder `/usr/local/cuda/targets/aarch64-linux/include` for nvcc 11.0 and larger. It has more than 5000 lines. One cannot simply copy and paste a version from Cuda 11 to our folder for Cuda 10.2 and hope it would work. The same applies to its companion `cuda_bf16.hpp` with 3800 lines. Since it is linked to version 11 or 12, the error messages keep expanding (e.g. `/usr/local/cuda/include/cuda_bf16.h:4322:10: fatal error: nv/target: No such file or directory`). We have two working options:

## 6. Option A: Create a `cuda_bf16.h` that redefines `nv_bfloat16` as `half`

Create two new files in the folder `/usr/local/cuda/include/`, starting with `cuda_bf16.h`. You need root privileges, so execute `sudo nano /usr/local/cuda/include/cuda_bf16.h` and give it the following content:

``` h
#ifndef CUDA_BF16_H
#define CUDA_BF16_H

#include <cuda_fp16.h>

// Define nv_bfloat16 as half
typedef half nv_bfloat16;

#endif // CUDA_BF16_H
```

Create the second file `sudo nano /usr/local/cuda/include/cuda_bf16.hpp` with the content

``` hpp
#ifndef CUDA_BF16_HPP
#define CUDA_BF16_HPP

#include "cuda_bf16.h"

namespace cuda {

    class BFloat16 {
    public:
        nv_bfloat16 value;

        __host__ __device__ BFloat16() : value(0) {}
        __host__ __device__ BFloat16(float f) { value = __float2half(f); }
        __host__ __device__ operator float() const { return __half2float(value); }
    };

} // namespace cuda

#endif // CUDA_BF16_HPP
```

## 6. Option B: Comment all code related to *bfloat16* in 3 files

The second solution is to remove all references to the *bfloat16* data type in the 3 files referencing them. First we have to __NOT__ include the nonexisting `cuda_bf16.h`. Just add two // in front of line 6 with `nano ggml/src/ggml-cuda/vendors/cuda.h`. After that it looks like this:

``` h
#include <cuda.h>
#include <cublas_v2.h>
//#include <cuda_bf16.h>
#include <cuda_fp16.h>
```

That is not enough, the new data type `nv_bfloat16` is referenced 8 times in 2 files. Replace each instance of them with `half`

- 684 in `ggml/src/ggml-cuda/convert.cu`
- 60 in `ggml/src/ggml-cuda/mmv.cu`
- 67 in `ggml/src/ggml-cuda/mmv.cu`
- 68 in `ggml/src/ggml-cuda/mmv.cu`
- 235 in `ggml/src/ggml-cuda/mmv.cu` (2x)
- 282 in `ggml/src/ggml-cuda/mmv.cu` (2x)

**DONE!** Only two more instructions left.


## 7. Execute `cmake -B build` with more flags to avoid the CUDA17 errors

We need to add a few extra flags to the recommended first instruction `cmake -B build`. If not done several errors like *Target "ggml-cuda" requires the language dialect "CUDA17" (with compiler extensions)* would stop the compilation. We still have a few warnings *constexpr if statements are a C++17 feature*, but we can ignore them.

``` sh
cmake -B build -DGGML_CUDA=ON -DLLAMA_CURL=ON -DCMAKE_CUDA_STANDARD=14 -DCMAKE_CUDA_STANDARD_REQUIRED=true -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_NATIVE=off
```

And 15 seconds later we're ready for the last step, the instruction that will take **85 minutes** (faster SD card: 60 minutes) to have llama.cpp compiled:

``` sh
cmake --build build --config Release
```

Successfully compiled! 
