from __future__ import division
from bokeh.plotting import cursession, figure, output_server, output_notebook, show
from copy import copy
from keras.callbacks import Callback
from numpy import inf, nan
from os import _exit
from Print import printflush


# The following defines a Class object that monitors and records
# certain key data from the Neural Network training process;
# it also includes a method "plot_learning_curves" that turns on a separate CPU process
# that plots the Training and Validation learning curves live
class NeuralNetworkTrainingMonitor(Callback):
    def __init__(self, reporting_freq=False, plot_title='Neural Network Learning Curves', bokeh_output='server'):
        super(Callback, self).__init__()
        self.latest_epoch = -1
        self.latest_batch = -1
        self.batches = []
        self.train_losses = []
        self.approx_train_acc_in_latest_epoch = 0.
        self.val_losses = []
        self.latest_val_acc = None
        self.min_val_loss = inf
        self.best_model = None
        self.best_model_epoch = None
        self.best_model_train_acc = None
        self.best_model_val_acc = None
        self.reporting_freq = reporting_freq

        printflush('\nConnecting to Bokeh Server for live Learning Curves plotting...\n')
        try:
            output_server('')
            self.bokeh_session = cursession()
            self.fig = figure(title=plot_title,
                              x_axis_label='# of Training Data Batches', y_axis_label='Loss',
                              plot_height=680, plot_width=880)
            self.fig.line((), (), name='TrainLoss', legend='Training Loss')
            self.fig.circle((), (), name='ValidLoss', legend='Validation Loss', color='red')
            show(self.fig)
            self.train_losses_curve_data_source = self.fig.select(dict(name='TrainLoss'))[0].data_source
            self.valid_losses_curve_data_source = self.fig.select(dict(name='ValidLoss'))[0].data_source
            printflush('\nConnecting to Bokeh Server for live Learning Curves plotting... done!\n')
        except:
            printflush('\nBokeh Server Connection *FAILED!*')
            printflush('Please make sure Bokeh package is already installed in Python, and')
            printflush('please open a new Command-Line Terminal window\n   (separate from this Terminal window)')
            printflush('   and run the following command firs to launch Bokeh Server:')
            printflush('       bokeh-server --backend=memory\n')
            _exit(0)

    def on_train_begin(self, logs={}):
        printflush('\nFFNN Training Progress')
        printflush('______________________')

    def on_epoch_begin(self, epoch, logs={}):
        self.latest_epoch += 1

    def on_batch_end(self, batch, logs={}):
        self.latest_batch += 1
        self.batches.append(self.latest_batch)
        self.train_losses.append(logs.get('loss'))
        train_acc = logs.get('acc')
        if not train_acc:
            train_acc = logs.get('accuracy')
        self.approx_train_acc_in_latest_epoch += (train_acc - self.approx_train_acc_in_latest_epoch) / (batch + 1)
        self.val_losses.append(logs.get('val_loss', nan))
        if self.reporting_freq and not(self.latest_batch % self.reporting_freq):
            self.report(batch_in_epoch=batch)

    def on_epoch_end(self, epoch, logs={}):
        current_val_loss = logs.get('val_loss')
        self.latest_val_acc = logs.get('val_acc')
        if not self.latest_val_acc:
            self.latest_val_acc = logs.get('val_accuracy')
        if current_val_loss is None:
            self.best_model = copy(self.model)
        else:
            self.val_losses[-1] = current_val_loss
            if current_val_loss < self.min_val_loss:
                self.min_val_loss = current_val_loss
                self.best_model = copy(self.model)
                self.best_model_epoch = epoch
                self.best_model_train_acc = self.approx_train_acc_in_latest_epoch
                self.best_model_val_acc = self.latest_val_acc
        if not self.reporting_freq:
            self.report()

    def on_train_end(self, logs={}):
        if self.reporting_freq:
            self.report()
        printflush('\nFFNN Training Finished! (%s Batches in total)\n'
                   % '{:,}'.format(self.latest_batch))
        if self.latest_val_acc is None:
            printflush('Training Accuracy (approx) = %s%%\n'
                       % '{:.1f}'.format(100. * self.approx_train_acc_in_latest_epoch))
        else:
            printflush('Best trained FFNN (with lowest Validation Loss) is from epoch #%s'
                       % '{:,}'.format(self.best_model_epoch))
            printflush('Training Accuracy (approx) = %s%%, Validation Accuracy = %s%%\n'
                       % ('{:.1f}'.format(100. * self.best_model_train_acc),
                          '{:.1f}'.format(100. * self.latest_val_acc)))

    def report(self, batch_in_epoch=None):
        if batch_in_epoch:
            batch_text = ' Batch ' + '{0:03}'.format(batch_in_epoch)
        else:
            batch_text = ''
        if self.latest_val_acc is None:
            val_acc_text = ''
        else:
            val_acc_text = 'ValidAcc (prev epoch)=' + '{:.1f}'.format(100. * self.latest_val_acc) + '%'
        printflush('Epoch %s%s: TrainAcc (approx)=%s%%, %s'
                   % ('{:,}'.format(self.latest_epoch),
                      batch_text,
                      '{:.1f}'.format(100. * self.approx_train_acc_in_latest_epoch),
                      val_acc_text), end='\r')

        self.train_losses_curve_data_source.data['x'] = self.batches
        self.train_losses_curve_data_source.data['y'] = self.train_losses

        self.valid_losses_curve_data_source.data['x'] = self.batches
        self.valid_losses_curve_data_source.data['y'] = self.val_losses

        self.bokeh_session.store_objects(self.train_losses_curve_data_source, self.valid_losses_curve_data_source)
