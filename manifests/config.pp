class hadoop::config {
  contain hadoop::common::config

  if $hadoop::daemon_namenode { contain hadoop::namenode::config }
  if $hadoop::daemon_datanode { contain hadoop::datanode::config }
  if $hadoop::daemon_journal { contain hadoop::journalnode::config }
  if $hadoop::daemon_zkfc { contain hadoop::zkfc::format }
  if $hadoop::daemon_resourcemanager { contain hadoop::resourcemanager::config }
  if $hadoop::daemon_nodemanager { contain hadoop::nodemanager::config }
  if $hadoop::daemon_historyserver { contain hadoop::historyserver::config }
  if $hadoop::daemon_timelineserver { contain hadoop::timelineserver::config }

}