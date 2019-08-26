# see: https://ttssh2.osdn.jp/manual/ja/reference/RE.txt

class Regexp::Node
  # parseはまだしないという決意をした
  # def self.parse...

  def to_s
    raise NotImplemented, 'this is abstract class'
  end

  def build
    Regexp.new(to_s)
  end

  # nodeをカッコで囲む。
  def group
    Regexp::Node::Grouping.new(self)
  end

  # キャプチャ用
  def capture(name)
    Regexp::Node::Grouping.new(self, capture: name)
  end
end

# TODO: 文字列をそのまま渡すのはマズいか？
def R(str)
  Regexp::Node::String.new(str)
end

class Regexp::Node::String < Regexp::Node
  def initialize(str)
    @source = Regexp.escape(str)
  end

  def to_s
    @source
  end
end

class Regexp::Node::Escaped < Regexp::Node
  def initialize(str)
    @source = str
  end

  def to_s
    "\\" + @source
  end
end

class Regexp::Node::Unicode < Regexp::Node
  def initialize(str)
    @source = str
  end

  def to_s
  end
end

class Regexp::Node::Sequence < Regexp::Node
  def initialize(*nodes)
    @nodes = nodes
  end

  def to_s
    @nodes.join
  end
end

class Regexp::Node::Choise < Regexp::Node
  def initialize(*nodes)
    @nodes = nodes
  end

  def to_s
    @nodes.join('|')
  end
end

class Regexp::Node::Comment < Regexp::Node
  def initialize(str)
    @str = str
  end

  def to_s
    "(?##{str})"
  end
end

class Regexp::Node::Grouping < Regexp::Node
  def initialize(node, capture: nil)
    @node = node
    @capture = capture
  end

  def to_s
    if @capture
      "(?<#{@capture}>#{@node})"
    else
      "(#{@node})"
    end
  end
end

module Regexp::Node::Constant
  Tab = Regexp::Node::Escaped.new("t")
  VTab = Regexp::Node::Escaped.new("v")
  Newline = Regexp::Node::Escaped.new("n")
  Return = Regexp::Node::Escaped.new("r")
  Backspace = Regexp::Node::Escaped.new("b")
  Feedforward = Regexp::Node::Escaped.new("f")
  Bell = Regexp::Node::Escaped.new("a")
  Escape = Regexp::Node::Escaped.new("e")
end
