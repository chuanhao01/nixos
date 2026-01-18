import subprocess
import typing as t
from dataclasses import dataclass

from libqtile.log_utils import logger


@dataclass
class HotkeyConfig:
    value: str
    hotkey: str


class Command:
    def __init__(self, run_args: t.Optional[t.Dict] = None) -> None:
        self.run_args: t.Dict[str, t.Any] = {}
        self.run_args = self.run_args if run_args is None else {**self.run_args, **run_args}

        self.completed_process: subprocess.CompletedProcess

    def _check_completed_process(self) -> None:
        if self.completed_process is None:
            logger.error("command_did_not_run|self.completed_process=%s", self.completed_process)
            raise Exception("command_did_not_run")

    def run(self, command: t.List[str]) -> None:
        return self._run(command, self.run_args)

    def _run(self, command: t.List[str], run_args: t.Optional[t.Dict] = None) -> None:
        logger.debug("command_run|command=%s,run_args=%s", command, run_args)
        self.completed_process = subprocess.run(  # pylint: disable=subprocess-run-check
            [*command],
            **({} if run_args is None else run_args),
        )

    def get_stdout_str(self) -> str:
        self._check_completed_process()
        stdout = self.completed_process.stdout
        assert isinstance(stdout, str)
        return stdout

    def get_error_code(self) -> int:
        self._check_completed_process()
        return self.completed_process.returncode

    def check_successful(self) -> bool:
        self._check_completed_process()
        return self.completed_process.returncode == 0


class CaptureCommand(Command):
    def __init__(self) -> None:
        super().__init__({"capture_output": True, "text": True, "shell": True})
