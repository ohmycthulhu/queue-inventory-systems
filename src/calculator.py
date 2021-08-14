class Formatter:
    def __init__(self, rows):
        self.rows = rows

    def header(self):
        return ','.join([row.get_name() for row in self.rows]) + '\r\n'

    def get(self):
        return ','.join([str(row.get_value()) for row in self.rows]) + '\r\n'


class Row:
    def __init__(self, name, func):
        self.name = name
        self.func = func

    def get_name(self):
        return self.name

    def get_value(self):
        return self.func()


class Exporter:
    def __init__(self, rows, next_func=None, items=None):
        self.formatter = Formatter(rows)
        self.next = next_func
        self.items = items if items is not None else []
        self.index = 0

    def set_iterator(self, next_func, items):
        self.next = next_func
        self.items = items
        self.index = 0

    def set_rows(self, rows):
        self.formatter = Formatter(rows)

    def __next__(self):
        if self.index >= len(self.items):
            raise StopIteration
        item = self.items[self.index]
        self.next(item)
        self.index += 1
        return self.formatter.get()

    def __iter__(self):
        self.index = 0
        return self

    def execute(self, file_name, func, items):
        self.set_iterator(func, items)
        with open(file_name, 'w') as file:
            file.write(self.formatter.header())
            for row in self:
                file.write(row)
