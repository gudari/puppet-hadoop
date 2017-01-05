class hadoop::config {
  contain hadoop::common::config


  if $hadoop::daemon_namenode {
    contain hadoop::namenode::config
  }

  if $hadoop::daemon_datanode {
    contain hadoop::datanode::config
  }

  if $hadoop::daemon_journal {
    contain hadoop::journalnode::config
  }

}