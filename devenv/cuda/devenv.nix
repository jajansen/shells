{ pkgs, ... }: {
  # Enable C and C++ language support with CMake
  languages.c.enable = true;
  languages.cpp.enable = true;

  # Explicitly include CMake if needed
  packages = [ pkgs.cmake ];

  # Optional: Set a specific CMake version
  # languages.cmake.version = "3.22.1";
}
