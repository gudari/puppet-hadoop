class hadoop::service {
  if $hadoop::daemon_namenode { contain hadoop::namenode::service }
  if $hadoop::daemon_datanode { contain hadoop::datanode::service }
  if $hadoop::daemon_journal { contain hadoop::journalnode::service }
  if $hadoop::daemon_zkfc { contain hadoop::zkfc::service }
  if $hadoop::daemon_resourcemanager { contain hadoop::resourcemanager::service }
  if $hadoop::daemon_nodemanager { contain hadoop::nodemanager::service }
  if $hadoop::daemon_historyserver { contain hadoop::historyserver::service }
}