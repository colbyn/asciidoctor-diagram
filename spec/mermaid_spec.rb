require_relative 'test_helper'

code = <<-eos
graph LR
    A[Square Rect] -- Link text --> B((Circle))
    A --> C(Round Rect)
    B --> D{Rhombus}
    C --> D
eos

describe Asciidoctor::Diagram::MermaidBlockMacroProcessor do
  include_examples "block_macro", :mermaid, code, [:png, :svg]
end

describe Asciidoctor::Diagram::MermaidBlockProcessor do
  include_examples "block", :mermaid, code, [:png, :svg]

  it "should respect the sequenceConfig attribute" do
    seq_diag = <<-eos
sequenceDiagram
    Alice->>John: Hello John, how are you?
    John-->>Alice: Great!
    eos

    seq_config = <<-eos
{
  "diagramMarginX": 0,
  "diagramMarginY": 0,
  "actorMargin": 0,
  "boxMargin": 0,
  "boxTextMargin": 0,
  "noteMargin": 0,
  "messageMargin": 0
}
    eos
    File.write('seqconfig.txt', seq_config)

    File.write('mermaid.txt', seq_diag)

    doc = <<-eos
= Hello, Mermaid!
Doc Writer <doc@example.com>

== First Section

mermaid::mermaid.txt["with_config", sequenceConfig="seqconfig.txt"]
mermaid::mermaid.txt["without_config"]
    eos

    load_asciidoc doc
    expect(File.exist?('with_config.png')).to be true
    expect(File.exist?('without_config.png')).to be true
    expect(File.size('with_config.png')).to_not be File.size('without_config.png')
  end

  it "should respect the width attribute" do
    seq_diag = <<-eos
sequenceDiagram
    Alice->>Bob: Hello Bob, how are you?
    Bob->>Claire: Hello Claire, how are you?
    Claire->>Doug: Hello Doug, how are you?
    eos

    File.write('mermaid.txt', seq_diag)

    doc = <<-eos
= Hello, Mermaid!
Doc Writer <doc@example.com>

== First Section

mermaid::mermaid.txt["with_width", width="700"]
mermaid::mermaid.txt["without_width"]
    eos

    load_asciidoc doc
    expect(File.exist?('with_width.png')).to be true
    expect(File.exist?('without_width.png')).to be true
    expect(File.size('with_width.png')).to_not be File.size('without_width.png')
  end

  it "should respect the theme attribute" do
    seq_diag = <<-eos
sequenceDiagram
    Alice->>Bob: Hello Bob, how are you?
    Bob->>Claire: Hello Claire, how are you?
    Claire->>Doug: Hello Doug, how are you?
    eos

    File.write('mermaid.txt', seq_diag)

    doc = <<-eos
= Hello, Mermaid!
Doc Writer <doc@example.com>

== First Section

mermaid::mermaid.txt["default", format="svg"]
mermaid::mermaid.txt["dark", format="svg", theme="dark"]
    eos

    load_asciidoc doc
    expect(File.exist?('default.svg')).to be true
    expect(File.exist?('dark.svg')).to be true
    expect(File.read('default.svg')).to_not be File.read('dark.svg')
  end

  it "should respect the puppeteerConfig attribute" do
    seq_diag = <<-eos
sequenceDiagram
    Alice->>John: Hello John, how are you?
    John-->>Alice: Great!
    eos

    pptr_config = <<-eos
{
    "args": ["--no-sandbox"]
}
    eos
    File.write('pptrconfig.txt', pptr_config)

    File.write('mermaid.txt', seq_diag)

    doc = <<-eos
= Hello, Mermaid!
Doc Writer <doc@example.com>

== First Section

mermaid::mermaid.txt["with_config", puppeteerConfig="pptrconfig.txt"]
mermaid::mermaid.txt["without_config"]
    eos

    load_asciidoc doc
    expect(File.exist?('with_config.png')).to be true
    expect(File.exist?('without_config.png')).to be true
    expect(File.size('with_config.png')).to be File.size('without_config.png')
  end
end
