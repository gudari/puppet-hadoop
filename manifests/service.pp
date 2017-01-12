class hadoop::service {
  if $hadoop::daemon_namenode { contain hadoop::namenode::service }
  if $hadoop::daemon_datanode { contain hadoop::datanode::service }
  if $hadoop::daemon_journal { contain hadoop::journalnode::service }
  if $hadoop::daemon_zkfc { contain hadoop::zkfc::service }
}