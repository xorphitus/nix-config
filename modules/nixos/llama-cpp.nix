{ pkgs, ... }:

# Reference: https://www.nijho.lt/post/llama-nixos/
(pkgs.llama-cpp.override {
  cudaSupport = true;
  rocmSupport = false;
  metalSupport = false;
  # Enable BLAS for optimized CPU layer performance (OpenBLAS)
  blasSupport = true;
}).overrideAttrs (oldAttrs: {
  # Enable native CPU optimizations (AVX, AVX2, etc.)
  cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
    "-DGGML_NATIVE=ON"
  ];
  # Disable Nix's march=native stripping
  preConfigure = ''
    export NIX_ENFORCE_NO_NATIVE=0
    ${oldAttrs.preConfigure or ""}
  '';
})
