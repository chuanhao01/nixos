import typing as t

T = t.TypeVar("T", str, int)  # pylint: disable=invalid-name


class Cycle(t.Generic[T]):
    def __init__(self) -> None:
        self.v_i_map: t.Dict[T, int] = {}
        self.i_v_map: t.Dict[int, T] = {}
        self.length = 0

    def __get_value(self, index: int) -> T:
        return self.i_v_map[index]

    def __get_index(self, value: T) -> int:
        return self.v_i_map[value]

    def add(self, value: T) -> None:
        self.v_i_map[value] = self.length
        self.i_v_map[self.length] = value
        self.length += 1

    def get_next(self, value: T) -> T:
        i = self.__get_index(value)
        return self.__get_value((i + 1) % self.length)

    def get_prev(self, value: T) -> T:
        i = self.__get_index(value)
        return self.__get_value((i - 1) % self.length)
