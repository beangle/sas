/*
 * Beangle, Agile Development Scaffold and Toolkits.
 *
 * Copyright © 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.sas.tomcat.juli;

import org.apache.juli.logging.Log;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ObjectStreamException;
import java.io.Serializable;

import static java.lang.String.valueOf;

/**
 * A Log facade
 *
 * @author Chaostone
 * @since 1.0.0
 */
public class SLF4JDelegatingLog implements Log, Serializable {

  private static final long serialVersionUID = 689548879679092807L;

  protected String name;

  static {
    SLF4JConfigurator.init();
  }

  /**
   * The delegate slf4j logger.
   * <p>
   * NOTE: in both {@code Log4jLogger} and {@code Jdk14Logger} classes in the
   * original JCL, as well as in the
   * {@code org.apache.commons.logging.impl.SLF4JLog} of
   * {@code jcl-over-slf4j}, the logger instance is <em>transient</em>, so we
   * do the same here.
   */
  private transient volatile Logger log;


  public SLF4JDelegatingLog() {
    super();
  }


  public SLF4JDelegatingLog(final String name) {
    super();
    setLogger(LoggerFactory.getLogger(name));
  }

  void setLogger(final Logger logger) {
    log = logger;
  }


  @Override
  public boolean isTraceEnabled() {
    return log.isTraceEnabled();
  }

  @Override
  public boolean isDebugEnabled() {
    return log.isDebugEnabled();
  }

  @Override
  public boolean isInfoEnabled() {
    return log.isInfoEnabled();
  }

  @Override
  public boolean isWarnEnabled() {
    return log.isWarnEnabled();
  }

  @Override
  public boolean isErrorEnabled() {
    return log.isErrorEnabled();
  }

  @Override
  public boolean isFatalEnabled() {
    return log.isErrorEnabled();
  }


  @Override
  public void trace(final Object msg) {
    trace(msg, null);
  }

  @Override
  public void trace(final Object msg, final Throwable thrown) {
    log.trace(valueOf(msg), thrown);
  }

  @Override
  public void debug(final Object msg) {
    debug(msg, null);
  }

  @Override
  public void debug(final Object msg, final Throwable thrown) {
    log.debug(valueOf(msg), thrown);
  }

  @Override
  public void info(final Object msg) {
    info(msg, null);
  }

  @Override
  public void info(final Object msg, final Throwable thrown) {
    log.info(valueOf(msg), thrown);
  }

  @Override
  public void warn(final Object msg) {
    warn(msg, null);
  }

  @Override
  public void warn(final Object msg, final Throwable thrown) {
    log.warn(String.valueOf(msg), thrown);
  }

  @Override
  public void error(final Object msg) {
    error(msg, null);
  }

  @Override
  public void error(final Object msg, final Throwable thrown) {
    log.error(valueOf(msg), thrown);
  }

  @Override
  public void fatal(final Object msg) {
    error(msg, null);
  }

  @Override
  public void fatal(final Object msg, final Throwable thrown) {
    error(msg, thrown);
  }

  protected Object readResolve() throws ObjectStreamException {
    return new SLF4JDelegatingLog(name);
  }
}
