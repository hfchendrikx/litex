import os
import subprocess


class CmakeProject():

    def __init__(self, project_dir, builder, name=None):
        self._project_dir = os.path.abspath(project_dir)
        self._builder = builder

        self._name = name
        if self._name is None:
            self._name = os.path.basename(self._project_dir)

        self.build_dir = os.path.join(self._builder.software_dir, self._name)

    def generate(self):
        os.makedirs(self.build_dir, exist_ok=True)
        toolchain_option = f"-DCMAKE_TOOLCHAIN_FILE={self._builder.get_cmake_toolchain_path()}"
        subprocess.check_call(["cmake", "-G", "Unix Makefiles", toolchain_option, self._project_dir],
                              cwd=self.build_dir)

    def build(self, target="litex_all"):
        subprocess.check_call(["cmake", "--build", self.build_dir, "--target", target], cwd=self.build_dir)
