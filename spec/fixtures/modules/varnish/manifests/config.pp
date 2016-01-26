# Configuration parameters
class varnish::config {

    require boxen::config

    $executable     = "${boxen::config::homebrewdir}/sbin/varnishd"
    $exec_name      = "${boxen::config::homebrewdir}/var/varnish"

    $configdir      = "${boxen::config::configdir}/varnish"
    $datadir        = "${boxen::config::datadir}/varnish"
    $logdir         = "${boxen::config::logdir}/varnish"

    $vclfile        = "${varnish::config::configdir}/default_boxen.vcl"
    $logfile        = "${varnish::config::logdir}/varnish.log"
}
