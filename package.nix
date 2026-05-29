{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  opencc,

  withColophon ? true,
  withCN ? true,
  withTW ? false,
}:

stdenv.mkDerivation rec {
  pname = "manpages-zh";
  version = "1.6.4.3";

  src = fetchFromGitHub {
    owner = "man-pages-zh";
    repo = "manpages-zh";
    rev = "v${version}";
    hash = "sha256-MTU86vNDjWR2f8G3FuN9Wwve5F1z4bM+glXWO8OLRUA=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = lib.optionals (withCN || withTW) [
    opencc
  ];

  postPatch = ''
    patchShebangs utils/
  '';

  # 根据项目的 CMake 参数进行定制
  cmakeFlags = [
    "-DENABLE_APPEND_COLOPHON=${if withColophon then "ON" else "OFF"}"
    "-DENABLE_ZHCN=${if withCN then "ON" else "OFF"}"
    "-DENABLE_ZHTW=${if withTW then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "Chinese Manual Pages (中文 man 手册页计划)";
    homepage = "https://github.com/man-pages-zh/manpages-zh";
    license = licenses.fdl12Plus;
    platforms = platforms.all;
    maintainers = [
      {
        email = "ardenet@qq.com";
        name = "Ardenet";
        github = "ardenet";
      }
    ];
  };
}
