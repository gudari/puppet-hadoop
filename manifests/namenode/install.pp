class hadoop::namenode::install {
  ensure_resource( 'class', '::hadoop::common::install')
}