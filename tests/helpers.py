import io


class StringIo(io.StringIO):
    """Convenience class to remove the \r characters from the return value -- make testing on Windoz easier."""

    def getvalue(self) -> str:
        return super().getvalue().replace("\r", "")
