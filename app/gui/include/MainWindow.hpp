#pragma once

#include <QMainWindow>
#include <QLabel>
#include <QImage>
#include <RenderController.hpp>

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    MainWindow();

public slots:
    void display(QImage image);

signals:
    void displayed();
private:
    RenderController renderController;
    QLabel *centralLabel;
};
