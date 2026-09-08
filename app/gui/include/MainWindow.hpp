#pragma once

#include <QMainWindow>
#include <QLabel>
#include <QImage>
#include <RenderController.hpp>

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    MainWindow();
    void resizeEvent (QResizeEvent*) override;

public slots:
    void display(QImage);

signals:
    void displayed();
    void sizeChanged(const QSize);
private:
    RenderController renderController;
    QLabel *centralLabel;
};
