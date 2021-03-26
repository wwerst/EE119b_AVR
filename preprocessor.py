

class ASMFileLine(object):

    def __init__(self, line: str):
        self.text_line = line

        comment_start_index = line.find(';')
        if comment_start_index >= 0:
            self.code = line[:comment_start_index]
            self.comment = line[comment_start_index:]
        else:
            self.code = line
            self.comment = ''

    @property
    def code_args(self):
        op_code = self.op_code
        post_opcode_index = self.code.find(op_code)
        post_opcode_code = self.code[post_opcode_index+len(op_code):]
        args = [arg.strip() for arg in post_opcode_code.split(',')]
        return args

    @property
    def op_code(self):
        code_words = self.code.split()
        if code_words:
            return code_words[0]
        return None

    def __repr__(self):
        output = self.code + self.comment
        return output.strip('\n')

    __str__ = __repr__


class ASMFileReader(object):

    def __init__(self, input_filename, output_folder):
        self._input_filename = input_filename
        self._output_folder = output_folder

    def convert_file(self):
        file_lines = []
        with open(self._input_filename, 'r') as file:
            for line in file.readlines():
                file_lines.append(ASMFileLine(line))

        output_lines = []

        for line in file_lines:
            if line.op_code == 'ASSERT':
                prev_line = output_lines[-1]
                assert_args = line.code_args
                mem_addr = assert_args[1].strip('$')
                mem_val = assert_args[0].strip('$')

                prev_line.comment = f';W {mem_val} {mem_addr}'
            elif line.op_code == 'RET':
                
                line.comment = (";" + line.code + " RET inst not allowed " + line.comment)
                line.code = ""
                output_lines.append(line)
            else:
                output_lines.append(line)

        file_name = self._input_filename.split('/')[-1]
        with open(self._output_folder + '/' + file_name, 'w') as file:
            for line in output_lines:
                file.write(line.__repr__() + '\n')



def main():
    reader = ASMFileReader('tests/alu_test_part1.asm', 'glen_output_asm')
    reader.convert_file()
    reader = ASMFileReader('tests/alu_test_part2.asm', 'glen_output_asm')
    reader.convert_file()


if __name__ == '__main__':
    main()
