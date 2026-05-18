{ pkgs, lib, ... }:
let
  cudaToolkit = pkgs.cudaPackages.cudatoolkit;
  nccl = pkgs.cudaPackages.nccl;
in
{
  # Core build tools
  packages = with pkgs; [
    cmake
    gcc
    gnumake
    ccache
    pkg-config
    # Libraries
    curl
    openssl
    # Cuda
    cudaPackages.cuda_nvcc
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.nccl
    cudaPackages.cudnn
  ];

  languages.python = {
    enable = true;
    uv.enable = true;
  };

  env = {
    CUDA_PATH = "${cudaToolkit}";
    CUDAToolkit_ROOT = "${cudaToolkit}";
    CUDAToolkit_INCLUDE_DIRS = "${cudaToolkit}/include";
    NCCL_ROOT = "${nccl}";
    NCCL_INCLUDE_DIR = "${nccl}/include";
    NCCL_LIBRARY = "${nccl}/lib/libnccl.so";
    OPENSSL_ROOT_DIR = "${pkgs.openssl.dev}";
  };

  enterShell = ''
    # Expose Nix store libs so prebuilt binaries (e.g. llama-server) can find
    # libstdc++.so.6, libssl.so.3, and libcrypto.so.3 via ldd / LD_LIBRARY_PATH.
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.openssl.out}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH=${cudaToolkit}/lib64:${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH
    export CMAKE_PREFIX_PATH=${nccl}:${cudaToolkit}:${pkgs.openssl.dev}:''${CMAKE_PREFIX_PATH:-}
  '';
}
