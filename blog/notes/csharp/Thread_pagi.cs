using System;
using System.Windows.Forms;
using System.Threading;
using System.IO;
using System.Threading.Tasks;

namespace test
{
    public partial class Form2 : Form
    {

        public Form2()
        {
            InitializeComponent();
            dataGridView1.DataSource = Class1.LoadLinksListFromFile("links.csv");
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int thread = 4;
            int start = 0;
            int end = 0;
            int total = dataGridView1.Rows.Count;
            int pagination = (int)Math.Round((decimal)total / thread);
            thread = (thread > total) ? total : thread;
            Thread[] threads = new Thread[thread];
            for (int l = 0; l < thread; l++)
            {
                if (l == 0)
                {
                    start = 0;
                    end = pagination;
                }
                else if (l == thread - 1)
                {
                    start = start + pagination;
                    end = total;
                }
                else
                {
                    start = start + pagination;
                    end = start + pagination;
                }

                //LogWriter writer = LogWriter.Instance;
                //writer.WriteToLog("Поток "+ l +" Начало " + start + " Конец " + end);

                Check ch = new Check(start, end);
                threads[l] = new Thread(new ThreadStart(() => ch.go()));
            }
            foreach (Thread t in threads)
            {
                t.Start();
            }
            foreach (Thread t in threads)
            {
                t.Join();
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
            /* Способ по новее в 4.0 */
            Parallel.For(0, 31, i =>
            {
                LogWriter writer = LogWriter.Instance;
                writer.WriteToLog("Строка"+i);
            });
        }

        private void toolStripStatusLabel2_Click(object sender, EventArgs e)
        {

        }
    }
    public class Check
    {
        private int start;
        private int end;

        public Check(int start, int end)
        {
            this.start = start;
            this.end = end;
        }
        public void go()
        {
            int i = 0;
            for (i = this.start; i < this.end; i++)
            {
                //dataGridView1.Rows[i].Cells[3].Value = "process Started";
                LogWriter writer = LogWriter.Instance;
                writer.WriteToLog("Строка" + i);
            }
        }
    }
}
