package org.microcurrencycore.qt;

import android.os.Bundle;
import android.system.ErrnoException;
import android.system.Os;

import org.qtproject.qt5.android.bindings.QtActivity;

import java.io.File;

public class MicrocurrencyQtActivity extends QtActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        final File microcurrencyDir = new File(getFilesDir().getAbsolutePath() + "/.microcurrency");
        if (!microcurrencyDir.exists()) {
            microcurrencyDir.mkdir();
        }

        super.onCreate(savedInstanceState);
    }
}
