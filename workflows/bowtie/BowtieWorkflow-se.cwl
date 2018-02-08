cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  fq: File
  all_alignment: boolean
  reference: File
  max_insert_size: int
  override_offrate: int
  max_ram_mb: int?
  sam: string

  bs_option: boolean
  samtools-view_result_file: string

  thread: int?

outputs:
  bowtie_version_stdout_result:
    type: File
    outputSource: bowtie_stdout/bowtie_version_stdout
  bowtie_version_result:
    type: File
    outputSource: bowtie_version/version_output
  bowtie_result:
    type: File
    outputSource: bowtie/bowtie_sam
  samtools_version_stderr_result:
    type: File
    outputSource: samtools_stderr/samtools_version_stderr
  samtools_version_result:
    type: File
    outputSource: samtools_version/version_output
  samtools-view_result:
    type: File
    outputSource: samtools-view/samtools-view_bam
  express_version_stderr_result:
    type: File
    outputSource: express_stderr/express_version_stderr
  express_version_result:
    type: File
    outputSource: express_version/version_output
  express_result:
    type:
      type: array
      items: File
    outputSource: express/express_result

steps:
  bowtie_stdout:
    run: bowtie-version.cwl
    in: []
    out: [bowtie_version_stdout]
  bowtie_version:
    run: ngs-version.cwl
    in:
      infile: bowtie_stdout/bowtie_version_stdout
    out: [version_output]
  bowtie:
    run: bowtie-se.cwl
    in:
      fq: fq
      reference: reference
      all_alignment: all_alignment
      max_insert_size: max_insert_size
      override_offrate: override_offrate
      max_ram_mb: max_ram_mb
      process: thread
      sam: sam
    out: [bowtie_sam]
  samtools_stderr:
    run: samtools-version.cwl
    in: []
    out: [samtools_version_stderr]
  samtools_version:
    run: ngs-version.cwl
    in:
      infile: samtools_stderr/samtools_version_stderr
    out: [version_output]
  samtools-view:
    run: samtools-view.cwl
    in:
      bs: bs_option
      bam: samtools-view_result_file
      sam: bowtie/bowtie_sam
    out: [samtools-view_bam]
  express_stderr:
    run: express-version.cwl
    in: []
    out: [express_version_stderr]
  express_version:
    run: ngs-version.cwl
    in:
      infile: express_stderr/express_version_stderr
    out: [version_output]
  express:
    run: express.cwl
    in:
      bam: samtools-view/samtools-view_bam
      reference: reference
    out: [express_result]
